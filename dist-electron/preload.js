"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const electron_1 = require("electron");
electron_1.contextBridge.exposeInMainWorld("electronAPI", {
    platform: process.platform,
    isElectron: true,
    versions: {
        node: process.versions.node,
        chrome: process.versions.chrome,
        electron: process.versions.electron,
    },
    onMessage: (callback) => {
        electron_1.ipcRenderer.on("message", (_event, message) => callback(message));
    },
});
