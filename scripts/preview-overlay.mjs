// Small control bar injected into the served Flutter shell. It polls
// /__preview/status and offers one-click (or one-keystroke) rebuilds of
// web_build/ from inside the Lovable preview — no GitHub Actions, no local
// toolchain.
//
// Shortcuts:
//   Ctrl/Cmd + Shift + B  → fast rebuild (incremental, skips pub/analyze)
//   Ctrl/Cmd + Shift + F  → full clean release rebuild
export const overlay = `<script>
(() => {
  // --- self-healing: a stale service worker or cached bundle is the #1 cause
  // of a blank Flutter preview inside the Lovable iframe. Kill both on boot.
  const KEY = "__vendoros_preview_recovered";
  (async () => {
    try {
      if (navigator.serviceWorker) {
        const regs = await navigator.serviceWorker.getRegistrations();
        await Promise.all(regs.map((r) => r.unregister()));
      }
      if (window.caches) {
        const keys = await caches.keys();
        await Promise.all(keys.map((k) => caches.delete(k)));
      }
    } catch (_) {}
  })();

  const hardReload = (why) => {
    if (sessionStorage.getItem(KEY) === "1") return; // only once per session
    sessionStorage.setItem(KEY, "1");
    console.warn("[preview] recovering blank preview:", why);
    const u = new URL(location.href);
    u.searchParams.set("__r", Date.now().toString(36));
    location.replace(u.toString());
  };

  // Watchdog: if Flutter never paints a view, force one cache-busting reload.
  // Reload that keeps the current route/hash but busts every asset cache, so a
  // finished rebuild lands in the preview without any manual refresh.
  const reloadApp = () => {
    const u = new URL(location.href);
    u.searchParams.set("__b", Date.now().toString(36));
    location.replace(u.toString());
  };

  const painted = () =>
    !!document.querySelector("flutter-view, flt-glass-pane, flt-scene-host, canvas");
  const startedAt = Date.now();
  const watchdog = setInterval(() => {
    if (painted()) { clearInterval(watchdog); sessionStorage.removeItem(KEY); return; }
    if (Date.now() - startedAt > 15000) {
      clearInterval(watchdog);
      hardReload("no Flutter view after 15s");
    }
  }, 1000);

  const bar = document.createElement("div");
  bar.style.cssText = "position:fixed;z-index:2147483647;left:12px;bottom:12px;" +
    "font:13px/1.4 ui-sans-serif,system-ui,sans-serif;color:#e8ecf4;" +
    "background:#14161cf2;border:1px solid #2a2f3a;border-radius:12px;" +
    "padding:8px 10px;display:flex;gap:8px;align-items:center;" +
    "box-shadow:0 8px 28px #0009;backdrop-filter:blur(8px);max-width:min(92vw,520px)";

  const dot = document.createElement("span");
  dot.style.cssText = "width:8px;height:8px;border-radius:50%;background:#4ade80;flex:0 0 auto";

  const label = document.createElement("span");
  label.style.cssText = "white-space:nowrap;overflow:hidden;text-overflow:ellipsis";
  label.textContent = "Preview up to date";

  const mkBtn = (text, bg, fg) => {
    const b = document.createElement("button");
    b.textContent = text;
    b.style.cssText = "font:inherit;font-weight:650;cursor:pointer;color:" + fg + ";" +
      "background:" + bg + ";border:0;border-radius:8px;padding:6px 11px;flex:0 0 auto";
    return b;
  };
  const fastBtn = mkBtn("Rebuild", "#7dd3fc", "#08090c");
  fastBtn.title = "Fast incremental rebuild (Ctrl/Cmd + Shift + B)";
  const fullBtn = mkBtn("Full", "#2a2f3a", "#cbd5e1");
  fullBtn.title = "Full clean release rebuild (Ctrl/Cmd + Shift + F)";
  const logBtn = mkBtn("Log", "transparent", "#94a3b8");
  logBtn.style.padding = "6px 6px";
  const hideBtn = mkBtn("×", "transparent", "#64748b");
  hideBtn.style.padding = "4px 7px";
  hideBtn.title = "Hide (press Ctrl/Cmd + Shift + B to rebuild anyway)";

  const logBox = document.createElement("pre");
  logBox.style.cssText = "position:fixed;z-index:2147483646;left:12px;bottom:64px;" +
    "width:min(92vw,640px);max-height:44vh;overflow:auto;display:none;margin:0;" +
    "font:11px/1.5 ui-monospace,SFMono-Regular,Menlo,monospace;color:#cbd5e1;" +
    "background:#0b0d12f2;border:1px solid #2a2f3a;border-radius:12px;padding:12px;" +
    "white-space:pre-wrap;box-shadow:0 8px 28px #0009";

  bar.append(dot, label, fastBtn, fullBtn, logBtn, hideBtn);
  document.body.append(bar, logBox);

  const toast = (msg) => { label.textContent = msg; };

  let wasBuilding = false;
  let hidden = false;
  let logOpen = false;

  const paint = (s) => {
    if (s.building) {
      wasBuilding = true;
      dot.style.background = "#fbbf24";
      const secs = s.startedAt ? Math.round((Date.now() - s.startedAt) / 1000) : 0;
      toast((s.mode === "full" ? "Full rebuild" : "Fast rebuild") + "… " + secs + "s");
      fastBtn.disabled = fullBtn.disabled = true;
      fastBtn.style.opacity = fullBtn.style.opacity = "0.5";
      bar.style.display = "flex";
      return;
    }
    fastBtn.disabled = fullBtn.disabled = false;
    fastBtn.style.opacity = fullBtn.style.opacity = "1";
    if (wasBuilding) { reloadApp(); return; }
    if (s.stale) {
      dot.style.background = "#f87171";
      toast("Preview is out of date with the Dart sources");
      bar.style.display = "flex";
    } else {
      dot.style.background = "#4ade80";
      toast("Preview up to date");
      bar.style.display = hidden ? "none" : "flex";
    }
  };

  async function poll() {
    try {
      const s = await fetch("/__preview/status", { cache: "no-store" }).then(r => r.json());
      paint(s);
      if (logOpen) {
        logBox.textContent = await fetch("/__preview/log", { cache: "no-store" }).then(r => r.text());
        logBox.scrollTop = logBox.scrollHeight;
      }
    } catch (_) { /* server restarting */ }
  }

  function rebuild(mode) {
    hidden = false;
    bar.style.display = "flex";
    dot.style.background = "#fbbf24";
    toast("Starting " + mode + " rebuild…");
    fastBtn.disabled = fullBtn.disabled = true;
    fetch("/__preview/rebuild?mode=" + mode).then(poll);
  }

  fastBtn.onclick = () => rebuild("fast");
  fullBtn.onclick = () => rebuild("full");
  logBtn.onclick = () => {
    logOpen = !logOpen;
    logBox.style.display = logOpen ? "block" : "none";
    poll();
  };
  hideBtn.onclick = () => { hidden = true; bar.style.display = "none"; };

  // Keyboard shortcuts work even when the Flutter canvas has focus.
  const onKey = (e) => {
    if (!(e.ctrlKey || e.metaKey) || !e.shiftKey) return;
    const k = (e.key || "").toLowerCase();
    if (k === "b") { e.preventDefault(); rebuild("fast"); }
    else if (k === "f") { e.preventDefault(); rebuild("full"); }
  };
  window.addEventListener("keydown", onKey, true);
  document.addEventListener("keydown", onKey, true);

  poll();
  setInterval(poll, 2000);
})();
</script>`;
