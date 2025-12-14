# GitHub Actions: Automated Build Guide

## What is GitHub Actions?

GitHub Actions automatically builds your DRIFT app whenever you push a version tag. No more manual building on your Windows PC!

### How it Works:
1. You push a version tag (like `v1.0.0`)
2. GitHub starts building on Windows, Mac, and Linux servers
3. Installers are uploaded to your GitHub Releases
4. Users can download and install your app

## Step 1: Push Your Code to GitHub

### First time setup:

```bash
# Initialize git (if not already done)
git init
git add .
git commit -m "Initial commit"

# Add your GitHub repo as remote
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git branch -M main
git push -u origin main
```

### After each change:

```bash
git add .
git commit -m "Your description of changes"
git push
```

## Step 2: Create a Release (Trigger the Build)

When you're ready to release a new version:

### Update version in package.json:
```json
{
  "version": "1.0.0"
}
```

### Create and push a tag:
```bash
git tag v1.0.0
git push origin v1.0.0
```

That's it! GitHub Actions will start building automatically.

## Step 3: Wait for Builds (Takes ~5-10 minutes)

1. Go to your GitHub repo
2. Click **Actions** tab
3. Watch the "Build and Release Electron App" workflow run
4. You'll see:
   - Windows build (windows-latest)
   - Mac build (macos-latest)
   - Linux build (ubuntu-latest)

## Step 4: Download Your Installers

Once all builds finish:

1. Go to **Releases** tab in GitHub
2. Find your new release (v1.0.0)
3. Download the `.exe` for Windows users
4. Download `.dmg` for Mac (optional)
5. Download `.zip` for Linux (optional)

## Understanding the Workflow

Your `.github/workflows/build-electron.yml` file does this:

1. **Checkout** - Gets your code
2. **Setup Node.js** - Installs Node 20
3. **Install dependencies** - Runs `npm ci` (clean install)
4. **Build** - Runs `npm run build` (backend + frontend)
5. **Compile Electron** - Runs `npx tsc -p tsconfig.electron.json`
6. **Publish** - Runs `npx electron-forge publish` which:
   - Creates installers (`.exe`, `.dmg`, `.zip`)
   - Automatically uploads to GitHub Releases
   - Creates a draft release for review

## Common Commands

### Push code without creating a release:
```bash
git add .
git commit -m "Bug fix"
git push
```
*(No tag = no build)*

### Create a release:
```bash
git tag v1.0.1
git push origin v1.0.1
```
*(This triggers the build)*

### Update version and release:
```bash
# Update package.json version to 1.0.1
npm version patch  # Automatically updates version and creates tag

git push && git push --tags
```

### View build logs:
1. Go to **Actions** tab
2. Click the workflow run
3. Click the job name to see detailed logs

## Troubleshooting

### Build Failed?

Check the logs:
1. Actions tab → Your failed build → Job name
2. Scroll to see what went wrong
3. Common issues:
   - Missing environment variables (DATABASE_URL, GEMINI_API_KEY)
   - Build script error (`npm run build` failed)
   - TypeScript compilation error (`tsc` failed)

### Release not showing up?

- Make sure you pushed the tag: `git push origin v1.0.0`
- Wait 1-2 minutes for GitHub to trigger the workflow
- Check **Actions** tab to see if workflow started

### Can't download installers?

- Build must complete successfully first
- Go to **Releases** tab (not Actions)
- Download from the release assets section

## Environment Variables (For Later)

If you add secret environment variables (like API keys) later:

1. Go to GitHub repo **Settings** → **Secrets and variables**
2. Create a secret (e.g., `GEMINI_API_KEY`)
3. Add to workflow:
   ```yaml
   env:
     GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
     GEMINI_API_KEY: ${{ secrets.GEMINI_API_KEY }}
   ```

Users still need `.env` file locally, but GitHub has its own secrets for builds.

## Version Numbering

Follow semantic versioning:
- `v1.0.0` - Major release (big new features)
- `v1.0.1` - Patch release (bug fixes)
- `v1.1.0` - Minor release (new features, backward compatible)

Example progression:
- v1.0.0 → v1.0.1 → v1.1.0 → v2.0.0

## Next Steps

1. **First push:** `git push -u origin main`
2. **Create tag:** `git tag v1.0.0 && git push origin v1.0.0`
3. **Watch:** Go to Actions tab
4. **Download:** Grab your `.exe` from Releases
5. **Share:** Give the `.exe` to anyone to install

That's it! GitHub does all the building for you from now on.
