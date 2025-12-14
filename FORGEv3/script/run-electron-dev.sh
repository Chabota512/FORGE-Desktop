#!/bin/bash
set -e

echo "🚀 Starting DRIFT in Electron development mode..."

echo "1. Compiling Electron TypeScript..."
npx tsc -p tsconfig.electron.json

echo "2. Starting development server and Electron..."
npm run dev &
SERVER_PID=$!

sleep 3

NODE_ENV=development npx electron .

kill $SERVER_PID 2>/dev/null || true
