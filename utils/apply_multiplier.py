#!/usr/bin/env python3
"""
Find (and optionally fix) resource values the mod forgot to multiply.

Compares every resource site of the vanilla game with the built mod:
  - add_resource = { type = X amount = N }
  - resources / build_cost_resources = { steel = N ... }   (production & costs)
  - modify_building_resources = { resource = X amount = N }
  - has_resources_in_country / has_resources_amount = { resource = X amount > N }
  - modifiers country_resource_X / state_resource_X / temporary_state_resource_X / local_resources_X

Sites are paired vanilla<->mod by structural position (enclosing block keys + kind),
not by line number, so this survives vanilla bumps. Per pair:
  mod == vanilla              -> UNPATCHED (fixed by --apply)
  mod == vanilla * multiplier -> ok
  anything else               -> custom ratio, reported, never touched

Vanilla files the mod does not override at all are reported too; --apply copies
them into the mod folder and multiplies them. Mod-only sites that are not a
multiple of the multiplier are reported for review.

Only .txt files under common/, events/, history/ are read: defines.lua is never touched.
After --apply, run `apply_patches.sh create --overwrite-sources ...` to regenerate patches.

Usage:
  apply_multiplier.py --original-folder <hoi4> --mod-folder <built mod> [--apply] [--multiplier 12] [--json out.json]
"""

import argparse
import bisect
import difflib
import json
import os
import re
import shutil
import sys

DIRS = ("common", "events", "history")
RESOURCES = {"oil", "steel", "aluminium", "rubber", "tungsten", "chromium", "coal"}
RES_ALT = "|".join(sorted(RESOURCES))
MODIFIER_KEY = re.compile(rf"^(country_resource|state_resource|temporary_state_resource|local_resources)_({RES_ALT})$")
TRIGGERS = {"has_resources_in_country", "has_resources_amount"}
COST_BLOCKS = {"resources", "build_cost_resources"}
# Cheap byte prefilter: a file without any of these has no site, skip tokenizing it.
PREFILTER = re.compile(rb"add_resource|resources|_resource_|local_resources_", re.I)
TOKEN = re.compile(r'#[^\n]*|"[^"]*"|[{}]|[<>!]?=|[<>]|[^\s{}=<>#"]+')
NUMBER = re.compile(r"^-?\d+(\.\d+)?$")
OPERATORS = {"=", "<", ">", "!=", "<=", ">="}


class Tok:
    __slots__ = ("text", "start", "end")

    def __init__(self, m):
        self.text, self.start, self.end = m.group(), m.start(), m.end()


def parse(toks, i=0):
    """Parse a token list into [(key, op, value)], value is a Tok or a nested list."""
    out = []
    n = len(toks)
    while i < n:
        t = toks[i].text
        if t == "}":
            return out, i + 1
        if t == "{":
            sub, i = parse(toks, i + 1)
            out.append((None, None, sub))
            continue
        if i + 2 < n and toks[i + 1].text in OPERATORS:
            op = toks[i + 1].text
            if toks[i + 2].text == "{":
                sub, i = parse(toks, i + 3)
                out.append((t, op, sub))
            else:
                out.append((t, op, toks[i + 2]))
                i += 3
        else:
            i += 1
    return out, i


def field(block, key):
    for k, op, v in block:
        if k == key and not isinstance(v, list):
            return op, v
    return None, None


def numeric(tok):
    return tok is not None and NUMBER.match(tok.text)


def collect_sites(tree):
    """Return [(signature, value_tok, op)] in document order."""
    sites = []

    def walk(block, path):
        for k, op, v in block:
            kl = k.lower() if k else k
            if isinstance(v, list):
                if kl == "add_resource":
                    _, typ = field(v, "type")
                    _, amt = field(v, "amount")
                    if numeric(amt) and (typ is None or typ.text != "any"):
                        sites.append((("add", typ.text if typ else "?", path), amt, ""))
                elif kl in COST_BLOCKS:
                    for k2, _, v2 in v:
                        if k2 in RESOURCES and not isinstance(v2, list) and numeric(v2):
                            sites.append((("cost", kl, k2, path), v2, ""))
                elif kl == "modify_building_resources" or kl in TRIGGERS:
                    _, res = field(v, "resource")
                    aop, amt = field(v, "amount")
                    if numeric(amt):
                        sites.append(((kl, res.text if res else "?", path), amt, aop))
                walk(v, path + (k,))
            elif k and MODIFIER_KEY.match(k) and numeric(v):
                sites.append((("modifier", k, path), v, ""))

    walk(tree, ())
    return sites


class File:
    def __init__(self, path):
        self.path = path
        with open(path, "rb") as f:
            raw = f.read()
        self.bom = raw.startswith(b"\xef\xbb\xbf")
        # surrogateescape: byte-exact round trip even for non-UTF-8 files
        self.text = raw[3 if self.bom else 0:].decode("utf-8", "surrogateescape")
        toks = [Tok(m) for m in TOKEN.finditer(self.text) if not m.group().startswith("#")]
        self.sites = collect_sites(parse(toks)[0])
        self._nl = None

    def line(self, offset):
        if self._nl is None:
            self._nl = [m.start() for m in re.finditer("\n", self.text)]
        return bisect.bisect_left(self._nl, offset) + 1

    def rewrite(self, edits):
        """edits: [(tok, new_text)]; asserts each token still holds its old text."""
        text = self.text
        for tok, new in sorted(edits, key=lambda e: e[0].start, reverse=True):
            assert text[tok.start:tok.end] == tok.text, (self.path, tok.start)
            text = text[:tok.start] + new + text[tok.end:]
        with open(self.path, "wb") as f:
            if self.bom:
                f.write(b"\xef\xbb\xbf")
            f.write(text.encode("utf-8", "surrogateescape"))


def candidate_files(root):
    out = set()
    for d in DIRS:
        for dp, _, fns in os.walk(os.path.join(root, d)):
            for fn in fns:
                if fn.endswith(".txt"):
                    p = os.path.join(dp, fn)
                    with open(p, "rb") as f:
                        if PREFILTER.search(f.read()):
                            out.add(os.path.relpath(p, root))
    return out


def fmt(x):
    return str(int(x)) if float(x).is_integer() else f"{x:g}"


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--original-folder", required=True)
    ap.add_argument("--mod-folder", required=True)
    ap.add_argument("--multiplier", type=float, default=12)
    ap.add_argument("--apply", action="store_true", help="fix UNPATCHED sites and import non-overridden vanilla files")
    ap.add_argument("--json", help="write the full report to this file")
    a = ap.parse_args()
    mult = a.multiplier

    vfiles, mfiles = candidate_files(a.original_folder), candidate_files(a.mod_folder)
    # A mod file without any site still overrides vanilla: check existence, not candidacy.
    report = {"unpatched": [], "custom": [], "not_overridden": [], "mod_only": [], "unaligned_vanilla": []}
    fixes = {}  # mod path -> (File, [(tok, new)])

    def row(rel, f, sig, tok, op, vanilla=None):
        r = {"file": rel, "line": f.line(tok.start), "kind": sig[0], "what": sig[1:-1], "op": op, "mod": tok.text}
        if vanilla is not None:
            r["vanilla"] = vanilla
            if float(vanilla):
                r["ratio"] = round(float(tok.text) / float(vanilla), 4)
        return r

    for rel in sorted(vfiles | mfiles):
        vpath, mpath = os.path.join(a.original_folder, rel), os.path.join(a.mod_folder, rel)
        if not os.path.exists(mpath):
            vf = File(vpath)
            live = [s for s in vf.sites if float(s[1].text) != 0]
            for sig, tok, op in live:
                report["not_overridden"].append(row(rel, vf, sig, tok, op, tok.text))
            if live and a.apply:
                os.makedirs(os.path.dirname(mpath), exist_ok=True)
                shutil.copyfile(vpath, mpath)
                mf = File(mpath)
                fixes[mpath] = (mf, [(tok, fmt(float(tok.text) * mult)) for _, tok, _ in mf.sites if float(tok.text) != 0])
            continue
        mf = File(mpath)
        if not os.path.exists(vpath):
            for sig, tok, op in mf.sites:
                if float(tok.text) % mult:
                    report["mod_only"].append(row(rel, mf, sig, tok, op))
            continue
        vf = File(vpath)
        sm = difflib.SequenceMatcher(None, [s[0] for s in vf.sites], [s[0] for s in mf.sites], autojunk=False)
        for tag, i1, i2, j1, j2 in sm.get_opcodes():
            if tag == "equal" or (tag == "replace" and i2 - i1 == j2 - j1):
                for (sig, vt, _), (_, mt, op) in zip(vf.sites[i1:i2], mf.sites[j1:j2]):
                    v, m = float(vt.text), float(mt.text)
                    if v == 0 or abs(m - v * mult) < 1e-9:
                        continue
                    if m == v:
                        report["unpatched"].append(row(rel, mf, sig, mt, op, vt.text))
                        fixes.setdefault(mpath, (mf, []))[1].append((mt, fmt(v * mult)))
                    else:
                        report["custom"].append(row(rel, mf, sig, mt, op, vt.text))
            else:
                for sig, tok, op in mf.sites[j1:j2]:
                    if float(tok.text) % mult:
                        report["mod_only"].append(row(rel, mf, sig, tok, op))
                for sig, tok, op in vf.sites[i1:i2]:
                    if float(tok.text):
                        report["unaligned_vanilla"].append(row(rel, vf, sig, tok, op, tok.text))

    if a.apply:
        for mf, edits in fixes.values():
            mf.rewrite(edits)

    for k, rows in report.items():
        print(f"\n== {k} ({len(rows)})")
        for r in rows:
            ratio = f" x{r['ratio']:g}" if "ratio" in r else ""
            van = f" vanilla={r['vanilla']}" if "vanilla" in r else ""
            print(f"  {r['file']}:{r['line']}  {r['kind']} {'/'.join(r['what'])} {r['op'] or '='} {r['mod']}{van}{ratio}")
    if a.apply:
        print(f"\nApplied {sum(len(e) for _, e in fixes.values())} edits in {len(fixes)} files.")
    if a.json:
        with open(a.json, "w") as f:
            json.dump(report, f, indent=1)


if __name__ == "__main__":
    sys.exit(main())
