// Fingerprints the Dart/web sources that affect the compiled web bundle.
// Used to auto-detect "the preview is stale" without any external CI.
import { createHash } from "node:crypto";
import { readdirSync, readFileSync, statSync, existsSync } from "node:fs";
import { join, resolve } from "node:path";

const ROOTS = ["lib", "web", "assets"];
const FILES = ["pubspec.yaml", "pubspec.lock"];

function walk(dir, out) {
  for (const entry of readdirSync(dir, { withFileTypes: true }).sort((a, b) =>
    a.name.localeCompare(b.name),
  )) {
    const p = join(dir, entry.name);
    if (entry.isDirectory()) walk(p, out);
    else out.push(p);
  }
  return out;
}

export function sourceHash(root = process.cwd()) {
  const hash = createHash("sha256");
  const files = [];
  for (const r of ROOTS) {
    const dir = resolve(root, r);
    if (existsSync(dir) && statSync(dir).isDirectory()) walk(dir, files);
  }
  for (const f of FILES) {
    const p = resolve(root, f);
    if (existsSync(p)) files.push(p);
  }
  for (const f of files) {
    hash.update(f.replace(root, ""));
    hash.update(readFileSync(f));
  }
  return hash.digest("hex").slice(0, 16);
}

export const HASH_FILE = "web_build/.source_hash";

export function builtHash(root = process.cwd()) {
  const p = resolve(root, HASH_FILE);
  return existsSync(p) ? readFileSync(p, "utf8").trim() : null;
}

if (import.meta.url === `file://${process.argv[1]}`) {
  console.log(sourceHash());
}
