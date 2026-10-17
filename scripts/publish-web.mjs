// One-click publish: syncs the freshly compiled Flutter web bundle into the
// tracked `web_build/` folder that the dev server and `npm run build` serve.
//
//   node scripts/publish-web.mjs
//
// `build/` is gitignored, so without this step the preview URL would keep
// serving the previously published bundle. Large debug-only artefacts are
// pruned so the tracked folder stays reasonably small.
import { cpSync, existsSync, rmSync, mkdirSync, readdirSync, statSync } from "node:fs";
import { writeFileSync } from "node:fs";
import { join, resolve } from "node:path";
import { sourceHash } from "./source-hash.mjs";

const source = resolve("build/web");
const target = resolve("web_build");

if (!existsSync(join(source, "index.html"))) {
  console.error(
    "No build/web/index.html — run `bash scripts/build-web.sh` (or `flutter build web --release`) first.",
  );
  process.exit(1);
}

rmSync(target, { recursive: true, force: true });
mkdirSync(target, { recursive: true });
cpSync(source, target, { recursive: true });

// Canonical standalone installer sources live under web/. Flutter normally
// copies them into build/web, but overlay them explicitly so a stale incremental
// Flutter output can never republish an older product picker or manifest.
for (const rel of [
  "firmware-installer.html",
  "firmware-installer-lamp-pro.html",
  "firmware-installer-lamp-lite.html",
  "firmware-installer-clock-pro.html",
  "firmware-installer-clock-lite.html",
  "firmware",
]) {
  const canonical = resolve("web", rel);
  if (existsSync(canonical)) {
    rmSync(join(target, rel), { recursive: true, force: true });
    cpSync(canonical, join(target, rel), { recursive: true });
  }
}

// Prune artefacts that are only useful for native debugging.
const prune = [
  "canvaskit/canvaskit.js.symbols",
  "canvaskit/chromium/canvaskit.js.symbols",
  "canvaskit/skwasm.js.symbols",
  "canvaskit/skwasm_heavy.js.symbols",
  "canvaskit/skwasm.wasm",
  "canvaskit/skwasm_heavy.wasm",
  "canvaskit/skwasm.js",
  "canvaskit/skwasm_heavy.js",
  "main.dart.js.map",
];
for (const rel of prune) rmSync(join(target, rel), { recursive: true, force: true });

// Stamp the source fingerprint so the dev server can tell whether the
// published bundle matches the current Dart sources.
writeFileSync(join(target, ".source_hash"), sourceHash() + "\n");

function dirSize(dir) {
  let total = 0;
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    const p = join(dir, entry.name);
    total += entry.isDirectory() ? dirSize(p) : statSync(p).size;
  }
  return total;
}

console.log(
  `Published build/web -> web_build (${(dirSize(target) / 1e6).toFixed(1)} MB). ` +
    "The preview URL serves this bundle after the next deploy.",
);
