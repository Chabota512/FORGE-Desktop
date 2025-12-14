# DRIFT Electron Desktop App - Windows Build Guide

This document explains how to build and run the DRIFT desktop application on Windows.

## What You Get

- **NSIS Installer** (`.exe`) - Professional Windows installer with auto-updates
- Standalone executable packaged with Node.js backend
- Bundled PostgreSQL database for offline operation

## Prerequisites for Windows

- **Node.js 20+** (Download from https://nodejs.org/)
- **npm** (Included with Node.js)
- **Visual Studio Build Tools** (Recommended for native module compilation)

## Step 1: Clone & Install

```bash
git clone <your-repo>
cd drift
npm install
```

## Step 2: Development Testing

Before building, test the app in development mode:

1. **Terminal 1 - Build the project:**
   ```bash
   npm run build
   ```

2. **Terminal 2 - Compile Electron files:**
   ```bash
   npx tsc -p tsconfig.electron.json
   ```

3. **Terminal 3 - Run Electron in development:**
   ```bash
   set NODE_ENV=development
   npx electron .
   ```

The app should open with dev tools. You can now test your changes live.

## Step 3: Build the Windows Installer

When ready to create a distributable installer:

```bash
npm run build
npx tsc -p tsconfig.electron.json
npx electron-forge make --config forge.config.ts
```

**Find your installer here:**
```
out/make/squirrel.windows/x64/DRIFT Setup.exe
```

You can now distribute this `.exe` file to users. They simply run the installer and DRIFT launches automatically.

## Step 4: Configure Environment

**Before running the installed app**, users must set up their environment variables:

1. Open `%APPDATA%\DRIFT\` (Press `Win+R`, type this path, press Enter)
2. Create a `.env` file with:
   ```
   DATABASE_URL=your_database_url
   GEMINI_API_KEY=your_api_key
   GROQ_API_KEY=your_groq_key
   SESSION_SECRET=your_session_secret
   ```

## Project Structure

- `electron/` - Electron main process (TypeScript)
- `dist-electron/` - Compiled Electron code
- `client/` - React frontend
- `server/` - Node.js/Express backend
- `forge.config.ts` - Electron Forge build settings
- `main.js` - Electron entry point

## Troubleshooting

**"App won't start after installation"**
- Verify `.env` file exists at `%APPDATA%\DRIFT\.env`
- Check all environment variables are set correctly

**"Module not found" errors**
- Run `npm install` again to ensure all dependencies are installed

**"Build fails with compilation errors"**
- Ensure Node.js 20+ is installed: `node --version`
- Delete `node_modules` and `package-lock.json`, then run `npm install` again
- Check that Visual Studio Build Tools are installed for native modules

**"Electron won't start in development"**
- Ensure Terminal 1 (`npm run build`) completed successfully
- Make sure Terminal 2 (`npx tsc -p tsconfig.electron.json`) finished without errors
- Check that port 5000 is not already in use
