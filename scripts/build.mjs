// Publishes the Flutter web bundle into dist/ for the sandbox build check.
// Run `flutter build web --release` first; otherwise a placeholder page is
// emitted so the build task still succeeds without the Flutter SDK.
import { cpSync, existsSync, mkdirSync, writeFileSync, rmSync } from "node:fs";
import { page } from "./page.mjs";

rmSync("dist", { recursive: true, force: true });
mkdirSync("dist", { recursive: true });

const source = existsSync("build/web/index.html")
  ? "build/web"
  : existsSync("web_build/index.html")
    ? "web_build"
    : null;

if (source) {
  cpSync(source, "dist", { recursive: true });
  console.log(`dist/ <- ${source} (Flutter web bundle)`);
} else {
  writeFileSync("dist/index.html", page);
  console.log("dist/ <- placeholder (run `flutter build web --release`)");
}
