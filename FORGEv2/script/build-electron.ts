import { execSync } from "child_process";
import * as fs from "fs";
import * as path from "path";

const rootDir = process.cwd();

console.log("🔨 Building DRIFT Electron App...\n");

console.log("1. Building backend and frontend...");
try {
  execSync("npm run build", { stdio: "inherit", cwd: rootDir });
  console.log("✅ Backend and frontend built successfully\n");
} catch (error) {
  console.error("❌ Failed to build backend/frontend");
  process.exit(1);
}

console.log("2. Compiling Electron main process...");
try {
  execSync("npx tsc -p tsconfig.electron.json", { stdio: "inherit", cwd: rootDir });
  console.log("✅ Electron main process compiled\n");
} catch (error) {
  console.error("❌ Failed to compile Electron main process");
  process.exit(1);
}

console.log("3. Creating package.json for Electron...");
const electronPackageJson = {
  name: "drift",
  version: "1.0.0",
  main: "electron/main.js",
  author: "DRIFT Team",
  description: "DRIFT - Study Schedule Manager",
  license: "MIT",
};

fs.writeFileSync(
  path.join(rootDir, "electron-package.json"),
  JSON.stringify(electronPackageJson, null, 2)
);
console.log("✅ Electron package.json created\n");

console.log("🎉 Build complete! You can now run:\n");
console.log("   For development: npx electron .");
console.log("   For packaging:   npx electron-forge package");
console.log("   For installers:  npx electron-forge make\n");
