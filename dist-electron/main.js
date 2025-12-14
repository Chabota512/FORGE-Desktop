"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
const electron_1 = require("electron");
const path = __importStar(require("path"));
const child_process_1 = require("child_process");
const fs = __importStar(require("fs"));
let mainWindow = null;
let serverProcess = null;
const PORT = 5000;
const isDev = process.env.NODE_ENV === "development" || !electron_1.app.isPackaged;
function getResourcePath(...paths) {
    if (electron_1.app.isPackaged) {
        return path.join(process.resourcesPath, ...paths);
    }
    return path.join(__dirname, "..", ...paths);
}
function getAppDataEnvPath() {
    if (process.platform === "win32") {
        const appData = process.env.APPDATA || "";
        return path.join(appData, "DRIFT", ".env");
    }
    else if (process.platform === "darwin") {
        return path.join(electron_1.app.getPath("userData"), ".env");
    }
    return path.join(electron_1.app.getPath("userData"), ".env");
}
async function startServer() {
    return new Promise((resolve, reject) => {
        const serverPath = getResourcePath("dist", "index.cjs");
        if (!fs.existsSync(serverPath)) {
            console.error("Server file not found:", serverPath);
            reject(new Error("Server file not found"));
            return;
        }
        console.log("Starting server from:", serverPath);
        const env = { ...process.env, PORT: String(PORT) };
        const envPaths = [
            getAppDataEnvPath(),
            path.join(electron_1.app.getPath("userData"), ".env"),
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
        const nodeExecutable = electron_1.app.isPackaged
            ? process.execPath
            : "node";
        if (electron_1.app.isPackaged) {
            env.ELECTRON_RUN_AS_NODE = "1";
        }
        serverProcess = (0, child_process_1.spawn)(nodeExecutable, [serverPath], {
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
function stopServer() {
    if (serverProcess) {
        console.log("Stopping server...");
        if (process.platform === "win32") {
            (0, child_process_1.spawn)("taskkill", ["/pid", String(serverProcess.pid), "/f", "/t"]);
        }
        else {
            serverProcess.kill("SIGTERM");
        }
        serverProcess = null;
    }
}
function createWindow() {
    mainWindow = new electron_1.BrowserWindow({
        width: 1400,
        height: 900,
        minWidth: 1024,
        minHeight: 700,
        webPreferences: {
            nodeIntegration: false,
            contextIsolation: true,
            preload: electron_1.app.isPackaged
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
        electron_1.shell.openExternal(url);
        return { action: "deny" };
    });
    mainWindow.on("closed", () => {
        mainWindow = null;
    });
    if (isDev) {
        mainWindow.webContents.openDevTools();
    }
    const template = [
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
                        dialog.showMessageBox(mainWindow, {
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
        template[2].submenu.push({ type: "separator" }, { role: "toggleDevTools" });
    }
    electron_1.Menu.setApplicationMenu(electron_1.Menu.buildFromTemplate(template));
}
electron_1.app.whenReady().then(async () => {
    try {
        if (!isDev) {
            await startServer();
        }
        createWindow();
    }
    catch (err) {
        console.error("Failed to start application:", err);
        electron_1.app.quit();
    }
});
electron_1.app.on("window-all-closed", () => {
    stopServer();
    if (process.platform !== "darwin") {
        electron_1.app.quit();
    }
});
electron_1.app.on("activate", () => {
    if (mainWindow === null) {
        createWindow();
    }
});
electron_1.app.on("before-quit", () => {
    stopServer();
});
