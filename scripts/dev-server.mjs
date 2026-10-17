// Static host for the Flutter web build of VendorOS.
//
// Build the bundle with:
//   flutter build web --release
// then this server serves build/web on PORT (default 8080). If the bundle is
// missing it falls back to an instructions page so the sandbox stays healthy.
import { createServer } from "node:http";
import { createReadStream, existsSync, readFileSync, statSync } from "node:fs";
import { spawn } from "node:child_process";
import { extname, join, normalize, resolve } from "node:path";
import { page } from "./page.mjs";
import { sourceHash, builtHash } from "./source-hash.mjs";
import { overlay } from "./preview-overlay.mjs";

const port = Number(process.env.PORT ?? 8080);
const webRoot = existsSync(resolve("build/web/index.html"))
  ? resolve("build/web")
  : resolve("web_build");

const MIME = {
  ".html": "text/html; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".mjs": "text/javascript; charset=utf-8",
  ".json": "application/json; charset=utf-8",
  ".css": "text/css; charset=utf-8",
  ".wasm": "application/wasm",
  ".png": "image/png",
  ".jpg": "image/jpeg",
  ".jpeg": "image/jpeg",
  ".svg": "image/svg+xml",
  ".ico": "image/x-icon",
  ".otf": "font/otf",
  ".ttf": "font/ttf",
  ".woff": "font/woff",
  ".woff2": "font/woff2",
  ".map": "application/json; charset=utf-8",
  ".symbols": "application/octet-stream",
  ".bin": "application/octet-stream",
};

function resolveFile(urlPath) {
  const clean = normalize(decodeURIComponent(urlPath.split("?")[0])).replace(
    /^(\.\.[/\\])+/,
    "",
  );
  let file = join(webRoot, clean);
  if (!file.startsWith(webRoot)) return null;
  if (existsSync(file) && statSync(file).isDirectory()) {
    file = join(file, "index.html");
  }
  if (existsSync(file) && statSync(file).isFile()) return file;
  // Single-page app fallback so deep links still boot the Flutter shell.
  const indexFile = join(webRoot, "index.html");
  return existsSync(indexFile) ? indexFile : null;
}

// --- Lovable-local preview mode -------------------------------------------
// The bundle is compiled here in the editor sandbox; no external CI needed.
let build = { running: false, code: null, startedAt: null, log: "", mode: null };

// mode "fast" reuses the incremental kernel cache and skips pub/analyze/smoke,
// so a small Dart edit lands in the preview much sooner than a full build.
function startBuild(mode = "fast") {
  if (build.running) return build;
  build = { running: true, code: null, startedAt: Date.now(), log: "", mode };
  const child = spawn("bash", ["scripts/build-web.sh"], {
    env: {
      ...process.env,
      SKIP_SMOKE: process.env.SKIP_SMOKE ?? "1",
      BUILD_MODE: mode,
    },
  });
  const collect = (d) => {
    build.log = (build.log + d.toString()).slice(-8000);
    process.stdout.write(d);
  };
  child.stdout.on("data", collect);
  child.stderr.on("data", collect);
  child.on("exit", (code) => {
    build.running = false;
    build.code = code;
  });
  return build;
}

function status() {
  const current = sourceHash();
  const built = builtHash();
  return {
    current,
    built,
    stale: built !== null && built !== current,
    building: build.running,
    mode: build.mode,
    lastExit: build.code,
    startedAt: build.startedAt,
  };
}

function json(res, body, code = 200) {
  res
    .writeHead(code, {
      "content-type": "application/json; charset=utf-8",
      "cache-control": "no-store",
    })
    .end(JSON.stringify(body));
}

createServer((req, res) => {
  const path = (req.url ?? "/").split("?")[0];

  if (path === "/__preview/status") return json(res, status());
  if (path === "/__preview/log") {
    res
      .writeHead(200, { "content-type": "text/plain; charset=utf-8", "cache-control": "no-store" })
      .end(build.log || "(no build output yet)");
    return;
  }
  if (path === "/__preview/rebuild") {
    const mode =
      new URL(req.url ?? "/", "http://x").searchParams.get("mode") === "full"
        ? "full"
        : "fast";
    startBuild(mode);
    return json(res, status(), 202);
  }

  if (req.url === "/health") {
    res.writeHead(200, { "content-type": "text/plain" }).end("ok");
    return;
  }

  // Kill-switch: any previously installed Flutter service worker gets a
  // self-unregistering script instead of the caching one, so the preview can
  // never be pinned to a stale bundle.
  if ((req.url ?? "").split("?")[0].endsWith("flutter_service_worker.js")) {
    res
      .writeHead(200, {
        "content-type": "text/javascript; charset=utf-8",
        "cache-control": "no-store",
      })
      .end(
        "self.addEventListener('install', () => self.skipWaiting());\n" +
          "self.addEventListener('activate', (e) => e.waitUntil((async () => {\n" +
          "  const keys = await caches.keys();\n" +
          "  await Promise.all(keys.map((k) => caches.delete(k)));\n" +
          "  await self.registration.unregister();\n" +
          "  const clients = await self.clients.matchAll({ type: 'window' });\n" +
          "  clients.forEach((c) => c.navigate(c.url));\n" +
          "})()));\n",
      );
    return;
  }

  const file = resolveFile(req.url ?? "/");
  if (!file) {
    res
      .writeHead(200, { "content-type": "text/html; charset=utf-8" })
      .end(page);
    return;
  }

  // Inject the rebuild banner into the shell so the stale-preview state is
  // visible and fixable with one click.
  if (extname(file) === ".html") {
    const html = readFileSync(file, "utf8").replace(
      "</body>",
      `${overlay}</body>`,
    );
    res
      .writeHead(200, {
        "content-type": "text/html; charset=utf-8",
        "cache-control": "no-store",
        "cross-origin-opener-policy": "same-origin",
        "cross-origin-embedder-policy": "credentialless",
      })
      .end(html);
    return;
  }

  const firmwareAsset =
    /^\/firmware-installer(?:-[a-z-]+)?\.html$/.test(path) || path.startsWith("/firmware/");

  res.writeHead(200, {
    "content-type": MIME[extname(file)] ?? "application/octet-stream",
    "cache-control": firmwareAsset
      ? "no-store, no-cache, must-revalidate, max-age=0"
      : "no-cache",
    // canvaskit / wasm need these for multi-threaded rendering paths.
    "cross-origin-opener-policy": "same-origin",
    "cross-origin-embedder-policy": "credentialless",
  });
  createReadStream(file).pipe(res);
}).listen(port, "0.0.0.0", () => {
  const mode = existsSync(join(webRoot, "index.html"))
    ? "serving build/web"
    : "no Flutter web build found — showing placeholder";
  console.log(`VendorOS host on http://localhost:${port} (${mode})`);
  const st = status();
  console.log(
    st.stale
      ? `[preview] bundle is STALE (built ${st.built}, sources ${st.current}) — click Rebuild in the preview banner`
      : "[preview] bundle matches current sources",
  );
  if ((process.env.AUTO_REBUILD ?? "1") === "1" && st.stale) startBuild("fast");
});

// --- Continuous auto-rebuild ----------------------------------------------
// Poll the source hash so every Dart/web edit triggers a fast rebuild without
// anyone clicking Rebuild in the preview banner.
if ((process.env.AUTO_REBUILD ?? "1") === "1") {
  const interval = Number(process.env.WATCH_INTERVAL_MS ?? 3000);
  let lastSeen = sourceHash();
  let settleAt = 0;
  setInterval(() => {
    if (build.running) return;
    const now = sourceHash();
    if (now !== lastSeen) {
      // Debounce: wait for one quiet tick so multi-file edits batch together.
      lastSeen = now;
      settleAt = Date.now() + interval;
      return;
    }
    if (settleAt && Date.now() >= settleAt && builtHash() !== now) {
      settleAt = 0;
      console.log(`[preview] sources changed (${now}) — auto rebuilding…`);
      startBuild("fast");
    }
  }, interval);
}
