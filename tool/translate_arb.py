#!/usr/bin/env python3
"""Translate the English ARB catalogue into the other shop languages.

Runs through the Lovable AI Gateway, one batch of keys at a time, and caches
every finished batch under .dart_tool/arb-cache so a re-run only asks for what
is still missing. Placeholders like {name} are checked on the way back: a reply
that loses or invents one is retried, then falls back to the English string so
the app never shows a broken sentence.
"""
import json
import os
import re
import sys
import time
import urllib.error
import urllib.request
from concurrent.futures import ThreadPoolExecutor

ARB_DIR = 'lib/l10n'
CACHE_DIR = '.dart_tool/arb-cache'
ENDPOINT = 'https://ai.gateway.lovable.dev/v1/chat/completions'
MODEL = 'google/gemini-3.8-flash'
BATCH = 40

LANGS = {
    'hi': 'Hindi (Devanagari script)',
    'te': 'Telugu',
    'kn': 'Kannada',
    'ml': 'Malayalam',
}

PROMPT = (
    'You are localising VendorOS, a billing, stock, credit-book and QR-ordering '
    'app used by small Indian shopkeepers, tea stalls, bakeries and street food '
    'vendors. Translate each English UI string into {lang}.\n'
    'Rules:\n'
    '- Keep every placeholder exactly as written, e.g. {{name}}, {{amount}}, '
    '{{count}}. Never translate, rename, drop or add one.\n'
    '- Keep ICU plural/select blocks intact, translating only the inner words.\n'
    '- Short, everyday shop language, not formal or literary. Keep button and '
    'tab labels as short as the English.\n'
    '- Keep Rs / ₹, numbers, GST, HSN, UPI, QR, KOT and brand names as they are.\n'
    '- Reply with a JSON object mapping every given key to its translation and '
    'nothing else.'
)

PH = re.compile(r'\{([a-zA-Z0-9_]+)\}')


def placeholders(text):
    return sorted(set(PH.findall(text)))


def ask(payload_keys, source, lang_name):
    body = json.dumps({
        'model': MODEL,
        'messages': [
            {'role': 'system', 'content': PROMPT.format(lang=lang_name)},
            {'role': 'user', 'content': json.dumps(
                {k: source[k] for k in payload_keys}, ensure_ascii=False)},
        ],
        'response_format': {'type': 'json_object'},
    }).encode()
    req = urllib.request.Request(ENDPOINT, data=body, headers={
        'Content-Type': 'application/json',
        'Lovable-API-Key': os.environ['LOVABLE_API_KEY'],
        'X-Lovable-AIG-SDK': 'fetch',
    })
    with urllib.request.urlopen(req, timeout=300) as res:
        out = json.load(res)
    text = out['choices'][0]['message']['content']
    text = text.strip().removeprefix('```json').removeprefix('```').removesuffix('```')
    return json.loads(text)


def translate_batch(job):
    code, lang_name, keys, source = job
    path = os.path.join(CACHE_DIR, f'{code}-{keys[0]}.json')
    if os.path.exists(path):
        return json.load(open(path))
    got = {}
    for attempt in range(4):
        pending = [k for k in keys if k not in got]
        if not pending:
            break
        try:
            reply = ask(pending, source, lang_name)
        except urllib.error.HTTPError as err:
            if err.code in (429, 500, 502, 503, 504):
                time.sleep(5 * (attempt + 1))
                continue
            raise SystemExit(f'gateway {err.code}: {err.read().decode()[:400]}')
        except Exception:
            time.sleep(3 * (attempt + 1))
            continue
        for key in pending:
            value = reply.get(key)
            if isinstance(value, str) and value.strip() and \
                    placeholders(value) == placeholders(source[key]):
                got[key] = value.strip()
    for key in keys:
        got.setdefault(key, source[key])
    json.dump(got, open(path, 'w'), ensure_ascii=False)
    return got


def main():
    os.makedirs(CACHE_DIR, exist_ok=True)
    template = json.load(open(f'{ARB_DIR}/app_en.arb'))
    keys = [k for k in template if not k.startswith('@')]
    source = {k: template[k] for k in keys}
    only = sys.argv[1:] or list(LANGS)

    jobs = []
    for code in only:
        for i in range(0, len(keys), BATCH):
            jobs.append((code, LANGS[code], keys[i:i + BATCH], source))

    done = 0
    with ThreadPoolExecutor(max_workers=6) as pool:
        results = []
        for out in pool.map(translate_batch, jobs):
            results.append(out)
            done += 1
            print(f'{done}/{len(jobs)} batches', flush=True)

    merged = {code: {} for code in only}
    for job, out in zip(jobs, results):
        merged[job[0]].update(out)

    for code in only:
        doc = {'@@locale': code}
        for key in keys:
            doc[key] = merged[code][key]
            meta = template.get('@' + key)
            if meta is not None:
                doc['@' + key] = meta
        with open(f'{ARB_DIR}/app_{code}.arb', 'w') as f:
            json.dump(doc, f, ensure_ascii=False, indent=2)
            f.write('\n')
        print(f'wrote {ARB_DIR}/app_{code}.arb')


if __name__ == '__main__':
    main()
