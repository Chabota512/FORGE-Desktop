import type { ForgeConfig } from "@electron-forge/shared-types";
import { MakerSquirrel } from "@electron-forge/maker-squirrel";
import { MakerZIP } from "@electron-forge/maker-zip";
import { PublisherGithub } from "@electron-forge/publisher-github";

const config: ForgeConfig = {
  packagerConfig: {
    name: "DRIFT",
    executableName: "drift",
    icon: "./client/public/favicon",
    asar: true,
    extraResource: [
      "./dist",
    ],
    ignore: (file: string) => {
      if (!file) return false;
      
      const keepPatterns = [
        /^\/package\.json$/,
        /^\/dist-electron/,
        /^\/node_modules/,
      ];
      
      for (const pattern of keepPatterns) {
        if (pattern.test(file)) return false;
      }
      
      const ignorePatterns = [
        /^\/client\/src/,
        /^\/electron$/,
        /^\/server/,
        /^\/shared/,
        /^\/migrations/,
        /^\/attached_assets/,
        /^\/\.git/,
        /^\/\.replit/,
        /^\/\.github/,
        /^\/forge_kb/,
        /^\/script/,
        /^\/dist$/,
        /\.ts$/,
        /\.tsx$/,
        /tsconfig.*\.json$/,
        /vite\.config\.ts$/,
        /drizzle\.config\.ts$/,
        /forge\.config\.ts$/,
        /replit\.md$/,
      ];
      
      for (const pattern of ignorePatterns) {
        if (pattern.test(file)) return true;
      }
      
      return false;
    },
  },
  rebuildConfig: {},
  makers: [
    new MakerSquirrel({
      name: "DRIFT",
      authors: "DRIFT Team",
      description: "DRIFT - Study Schedule Manager",
    }),
    new MakerZIP({}, ["darwin", "linux", "win32"]),
  ],
  publishers: [
    new PublisherGithub({
      repository: {
        owner: "Chabota512",
        name: "FORGE_electron",
      },
      draft: false,
      prerelease: false,
    }),
  ],
  plugins: [],
};

export default config;
