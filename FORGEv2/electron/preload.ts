import { contextBridge, ipcRenderer } from "electron";

contextBridge.exposeInMainWorld("electronAPI", {
  platform: process.platform,
  isElectron: true,
  versions: {
    node: process.versions.node,
    chrome: process.versions.chrome,
    electron: process.versions.electron,
  },
  onMessage: (callback: (message: string) => void) => {
    ipcRenderer.on("message", (_event, message) => callback(message));
  },
});
