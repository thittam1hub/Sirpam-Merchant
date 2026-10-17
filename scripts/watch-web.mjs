// Auto-detect trigger: watches Dart/web sources and rebuilds the web bundle
// whenever they change, so the preview never serves a stale snapshot.
//
//   node scripts/watch-web.mjs        # poll every 3s, rebuild on change
//   WATCH_INTERVAL_MS=1000 node scripts/watch-web.mjs
//
// Runs entirely inside Lovable — no GitHub Actions required.
import { spawn } from "node:child_process";
import { sourceHash, builtHash } from "./source-hash.mjs";

const interval = Number(process.env.WATCH_INTERVAL_MS ?? 3000);
let building = false;
let pending = false;

function rebuild(reason) {
  if (building) {
    pending = true;
    return;
  }
  building = true;
  console.log(`[watch-web] ${reason} → rebuilding…`);
  const child = spawn("bash", ["scripts/build-web.sh"], {
    stdio: "inherit",
    env: {
      ...process.env,
      SKIP_SMOKE: process.env.SKIP_SMOKE ?? "1",
      // Watch-triggered rebuilds are small Dart edits: use the incremental
      // path. Set BUILD_MODE=full for optimised release output.
      BUILD_MODE: process.env.BUILD_MODE ?? "fast",
    },
  });
  child.on("exit", (code) => {
    building = false;
    console.log(
      code === 0
        ? "[watch-web] bundle published to web_build/ — refresh the preview"
        : `[watch-web] build failed (exit ${code})`,
    );
    if (pending) {
      pending = false;
      rebuild("queued change");
    }
  });
}

let last = builtHash();
console.log(`[watch-web] watching sources (built=${last ?? "none"})`);
if (sourceHash() !== last) rebuild("sources differ from published bundle");

setInterval(() => {
  const now = sourceHash();
  if (now !== last && !building) {
    last = now;
    rebuild(`source hash ${now}`);
  } else {
    last = now;
  }
}, interval);
