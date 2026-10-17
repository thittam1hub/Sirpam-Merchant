#!/usr/bin/env python3
"""Smoke test: serve the Flutter web bundle and assert the onboarding screen renders.

Usage:  python3 scripts/smoke_web.py [--port 8091]

Assumes a bundle exists in build/web or web_build (run scripts/build-web.sh
first — `npm run smoke:web` does both). Runs headless Chromium with *no*
locale hints, which is exactly the condition that used to trigger
"Incorrect locale information provided".
"""
from __future__ import annotations

import argparse
import asyncio
import subprocess
import sys
import time
from pathlib import Path

from playwright.async_api import async_playwright

ROOT = Path(__file__).resolve().parent.parent
SHOTS = ROOT / "build" / "smoke"


async def run(port: int) -> int:
    SHOTS.mkdir(parents=True, exist_ok=True)
    server = subprocess.Popen(
        ["node", "scripts/dev-server.mjs"],
        cwd=ROOT,
        env={"PATH": "/usr/bin:/bin:/usr/local/bin", "PORT": str(port)},
        stdout=subprocess.DEVNULL,
        stderr=subprocess.STDOUT,
    )
    try:
        # Wait for the host to answer.
        import urllib.request

        for _ in range(60):
            try:
                urllib.request.urlopen(f"http://localhost:{port}/health", timeout=1)
                break
            except Exception:
                time.sleep(0.5)
        else:
            print("FAIL: dev server never came up")
            return 1

        errors: list[str] = []
        async with async_playwright() as pw:
            browser = await pw.chromium.launch(headless=True)
            context = await browser.new_context(viewport={"width": 1280, "height": 1800})
            page = await context.new_page()
            page.on("pageerror", lambda e: errors.append(str(e)))
            page.on(
                "console",
                lambda m: errors.append(m.text) if m.type == "error" else None,
            )

            await page.goto(f"http://localhost:{port}/", wait_until="domcontentloaded")
            await page.wait_for_selector(
                "flutter-view, flt-glass-pane", state="attached", timeout=60_000
            )
            # First frame removes the boot splash (see web/index.html).
            await page.wait_for_function(
                "() => { const s = document.getElementById('boot-splash');"
                " return !s || s.classList.contains('hidden'); }",
                timeout=60_000,
            )
            await page.wait_for_timeout(2500)
            await page.screenshot(path=str(SHOTS / "onboarding.png"))

            # CanvasKit paints into a canvas nested in shadow roots.
            has_canvas = await page.evaluate(
                """() => {
                  const walk = (root) => {
                    if (root.querySelector('canvas')) return true;
                    for (const el of root.querySelectorAll('*')) {
                      if (el.shadowRoot && walk(el.shadowRoot)) return true;
                    }
                    return false;
                  };
                  return walk(document);
                }"""
            )
            await browser.close()

        # The onboarding screen must actually be painted, not a blank canvas.
        from PIL import Image

        img = Image.open(SHOTS / "onboarding.png").convert("L")
        colours = len(img.getcolors(maxcolors=1_000_000) or [])
        painted = colours > 12

        locale_errors = [e for e in errors if "locale" in e.lower()]
        ok = True
        if locale_errors:
            print("FAIL: locale error present:", locale_errors[0])
            ok = False
        if not has_canvas:
            print("FAIL: Flutter never created a render canvas")
            ok = False
        if not painted:
            print(f"FAIL: screen looks blank ({colours} distinct tones)")
            ok = False
        if errors and ok:
            print("note: non-fatal console errors:", errors[:3])
        if ok:
            print(
                "PASS: onboarding screen rendered headlessly "
                f"({colours} tones, {SHOTS / 'onboarding.png'})"
            )
        return 0 if ok else 1
    finally:
        server.terminate()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--port", type=int, default=8091)
    args = parser.parse_args()
    if not (ROOT / "build/web/index.html").exists() and not (
        ROOT / "web_build/index.html"
    ).exists():
        print("FAIL: no web bundle. Run `bash scripts/build-web.sh` first.")
        return 1
    return asyncio.run(run(args.port))


if __name__ == "__main__":
    sys.exit(main())
