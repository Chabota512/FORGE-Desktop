# DRIFT Desktop App - Windows Setup Guide

## What's in This Folder

This is a complete, ready-to-build Electron application for Windows. Everything you need is here except `node_modules` (which you'll install with npm).

## Quick Start (3 Steps)

### Step 1: Install Dependencies
```bash
npm install
```

### Step 2: Build the Project
```bash
npm run build
```

### Step 3: Create the Windows Installer
```bash
npx tsc -p tsconfig.electron.json
npx electron-forge make --config forge.config.ts
```

**Your installer will be at:**
```
out/make/squirrel.windows/x64/DRIFT Setup.exe
```

## Before First Run: Set Up Environment Variables

Create a `.env` file at: `%APPDATA%\DRIFT\.env`

1. Press `Win+R`
2. Type: `%APPDATA%\DRIFT\`
3. Create a `.env` file with:
   ```
   DATABASE_URL=your_postgres_url
   GEMINI_API_KEY=your_api_key
   GROQ_API_KEY=your_groq_key
   SESSION_SECRET=any_random_secret
   ```

## Testing Before Building (Optional)

Want to test before building the installer? Open **3 separate terminals**:

**Terminal 1:**
```bash
npm run build
```

**Terminal 2:**
```bash
npx tsc -p tsconfig.electron.json
```

**Terminal 3:**
```bash
set NODE_ENV=development
npx electron .
```

The app will open with dev tools - you can test everything before creating the installer.

## Folder Structure

- `client/` - React frontend code
- `server/` - Express backend code
- `electron/` - Electron main process code
- `shared/` - Shared types and schemas
- `migrations/` - Database migrations
- `forge.config.ts` - Electron build configuration
- `ELECTRON_README.md` - Detailed technical documentation

## System Requirements

- **Node.js 20+** (https://nodejs.org)
- **npm** (comes with Node.js)
- **Windows 7+**
- **Visual Studio Build Tools** (for native modules - optional but recommended)

## Need Help?

See `ELECTRON_README.md` for detailed troubleshooting and advanced options.
