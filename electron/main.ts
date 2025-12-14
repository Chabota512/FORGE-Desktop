import { app, BrowserWindow, Menu, shell } from "electron";
import * as path from "path";
import { spawn, ChildProcess } from "child_process";
import * as fs from "fs";

let mainWindow: BrowserWindow | null = null;
let serverProcess: ChildProcess | null = null;
const PORT = 5000;

const isDev = process.env.NODE_ENV === "development" || !app.isPackaged;

function getResourcePath(...paths: string[]): string {
  if (app.isPackaged) {
    return path.join(process.resourcesPath, ...paths);
  }
  return path.join(__dirname, "..", ...paths);
}

function getAppDataEnvPath(): string {
  if (process.platform === "win32") {
    const appData = process.env.APPDATA || "";
    return path.join(appData, "DRIFT", ".env");
  } else if (process.platform === "darwin") {
    return path.join(app.getPath("userData"), ".env");
  }
  return path.join(app.getPath("userData"), ".env");
}

async function startServer(): Promise<void> {
  return new Promise((resolve, reject) => {
    const serverPath = getResourcePath("dist", "index.cjs");
    
    if (!fs.existsSync(serverPath)) {
      console.error("Server file not found:", serverPath);
      reject(new Error("Server file not found"));
      return;
    }

    console.log("Starting server from:", serverPath);

    const env: Record<string, string | undefined> = { ...process.env, PORT: String(PORT) };

    const envPaths = [
      getAppDataEnvPath(),
      path.join(app.getPath("userData"), ".env"),
      path.join(process.cwd(), ".env"),
    ];

    for (const envPath of envPaths) {
      if (fs.existsSync(envPath)) {
        console.log("Loading .env from:", envPath);
        const envContent = fs.readFileSync(envPath, "utf-8");
        envContent.split("\n").forEach((line) => {
          const match = line.match(/^([^=]+)=(.*)$/);
          if (match && !line.startsWith("#")) {
            env[match[1].trim()] = match[2].trim();
          }
        });
        break;
      }
    }

    const nodeExecutable = app.isPackaged 
      ? process.execPath 
      : "node";
    
    if (app.isPackaged) {
      env.ELECTRON_RUN_AS_NODE = "1";
    }

    serverProcess = spawn(nodeExecutable, [serverPath], {
      env,
      cwd: getResourcePath(),
      stdio: ["pipe", "pipe", "pipe"],
    });

    serverProcess.stdout?.on("data", (data) => {
      console.log(`Server: ${data}`);
      if (data.toString().includes("serving on port") || data.toString().includes("listening")) {
        resolve();
      }
    });

    serverProcess.stderr?.on("data", (data) => {
      console.error(`Server Error: ${data}`);
    });

    serverProcess.on("error", (err) => {
      console.error("Failed to start server:", err);
      reject(err);
    });

    serverProcess.on("close", (code) => {
      console.log(`Server process exited with code ${code}`);
      serverProcess = null;
    });

    setTimeout(() => resolve(), 3000);
  });
}

function stopServer(): void {
  if (serverProcess) {
    console.log("Stopping server...");
    if (process.platform === "win32") {
      spawn("taskkill", ["/pid", String(serverProcess.pid), "/f", "/t"]);
    } else {
      serverProcess.kill("SIGTERM");
    }
    serverProcess = null;
  }
}

function createWindow(): void {
  mainWindow = new BrowserWindow({
    width: 1400,
    height: 900,
    minWidth: 1024,
    minHeight: 700,
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true,
      preload: app.isPackaged 
        ? path.join(__dirname, "preload.js")
        : path.join(__dirname, "..", "dist-electron", "preload.js"),
    },
    icon: path.join(__dirname, "..", "client", "public", "favicon.png"),
    show: false,
    backgroundColor: "#0a0a0a",
  });

  mainWindow.once("ready-to-show", () => {
    mainWindow?.show();
  });

  const startUrl = `http://localhost:${PORT}`;
  console.log("Loading URL:", startUrl);
  mainWindow.loadURL(startUrl);

  mainWindow.webContents.setWindowOpenHandler(({ url }) => {
    shell.openExternal(url);
    return { action: "deny" };
  });

  mainWindow.on("closed", () => {
    mainWindow = null;
  });

  if (isDev) {
    mainWindow.webContents.openDevTools();
  }

  const template: Electron.MenuItemConstructorOptions[] = [
    {
      label: "File",
      submenu: [
        { role: "quit" }
      ]
    },
    {
      label: "Edit",
      submenu: [
        { role: "undo" },
        { role: "redo" },
        { type: "separator" },
        { role: "cut" },
        { role: "copy" },
        { role: "paste" },
        { role: "selectAll" }
      ]
    },
    {
      label: "View",
      submenu: [
        { role: "reload" },
        { role: "forceReload" },
        { type: "separator" },
        { role: "resetZoom" },
        { role: "zoomIn" },
        { role: "zoomOut" },
        { type: "separator" },
        { role: "togglefullscreen" }
      ]
    },
    {
      label: "Help",
      submenu: [
        {
          label: "About",
          click: () => {
            const { dialog } = require("electron");
            dialog.showMessageBox(mainWindow!, {
              type: "info",
              title: "About",
              message: "DRIFT - Study Schedule Manager",
              detail: "Version 1.0.0\nBuilt with Electron"
            });
          }
        }
      ]
    }
  ];

  if (isDev) {
    (template[2].submenu as Electron.MenuItemConstructorOptions[]).push(
      { type: "separator" },
      { role: "toggleDevTools" }
    );
  }

  Menu.setApplicationMenu(Menu.buildFromTemplate(template));
}

app.whenReady().then(async () => {
  try {
    if (!isDev) {
      await startServer();
    }
    createWindow();
  } catch (err) {
    console.error("Failed to start application:", err);
    app.quit();
  }
});

app.on("window-all-closed", () => {
  stopServer();
  if (process.platform !== "darwin") {
    app.quit();
  }
});

app.on("activate", () => {
  if (mainWindow === null) {
    createWindow();
  }
});

app.on("before-quit", () => {
  stopServer();
});
