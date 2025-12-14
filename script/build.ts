import { execSync } from "child_process";
import * as esbuild from "esbuild";

async function build() {
  try {
    console.log("🔨 Building DRIFT application...");

    // Build client
    console.log("📦 Building client (Vite)...");
    execSync("vite build --mode production", { stdio: "inherit" });

    // Build server
    console.log("📦 Building server (esbuild)...");
    await esbuild.build({
      entryPoints: ["server/index.ts"],
      bundle: true,
      platform: "node",
      target: "node20",
      outfile: "dist/index.cjs",
      external: [
        "better-sqlite3",
        "postgres",
        "@neondatabase/serverless",
        "express",
        "multer",
        "dotenv",
        "esbuild",
        "vite",
        "@vitejs/plugin-react",
        "tailwindcss",
        "@tailwindcss/oxide",
        "@tailwindcss/vite",
        "sharp",
        "onnxruntime-node",
        "@xenova/transformers",
        "@babel/core",
        "lightningcss",
        "chromadb",
      ],
      format: "cjs",
      logLevel: "info",
    });

    console.log("✅ Build completed successfully!");
  } catch (error) {
    console.error("❌ Build failed:", error);
    process.exit(1);
  }
}

build();
