#!/usr/bin/env python3
"""Generate a landing page for the GitHub Pages artifact root.

Lists every subdirectory of the deployment root (one per rendered Quarto
site) and writes an index.html linking to each, using the site's own
<title> tag as the card label when available.

The list is regenerated on every deploy, so adding a new project folder to
the artifact automatically adds it to the landing page. GitHub Pages does
not expose directory listings, so the page must be generated at build time.

Usage: python generate-pages-index.py <public_dir>
"""

import re
import sys
from html import escape, unescape
from pathlib import Path

TITLE_RE = re.compile(r"<title>(.*?)</title>", re.S)


def site_title(site_dir: Path) -> str:
    """Extract <title> from the site's index.html, falling back to the folder name."""
    index = site_dir / "index.html"
    if index.is_file():
        match = TITLE_RE.search(index.read_text(encoding="utf-8", errors="replace"))
        if match:
            return match.group(1).strip()
    return site_dir.name


def main() -> int:
    if len(sys.argv) != 2:
        print(f"usage: {sys.argv[0]} <public_dir>", file=sys.stderr)
        return 2

    public = Path(sys.argv[1])
    if not public.is_dir():
        print(f"error: {public} is not a directory", file=sys.stderr)
        return 1

    sites = sorted(
        (p for p in public.iterdir() if p.is_dir() and not p.name.startswith(".")),
        key=lambda p: p.name.lower(),
    )

    if sites:
        cards = "\n".join(
            f'        <a class="card" href="./{site.name}/">'
            f"<h2>{escape(unescape(site_title(site)))}</h2>"
            f"<p>{escape(site.name)}</p></a>"
            for site in sites
        )
    else:
        cards = "        <p>No projects published yet.</p>"

    html = f"""<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>rondemy — projects</title>
  <style>
    body {{ font-family: system-ui, sans-serif; margin: 0; background: #fafafa; color: #222; }}
    main {{ max-width: 56rem; margin: 0 auto; padding: 3rem 1.5rem; }}
    h1 {{ margin-bottom: 0.25rem; }}
    .subtitle {{ color: #666; margin-top: 0; }}
    .cards {{ display: grid; grid-template-columns: repeat(auto-fill, minmax(15rem, 1fr)); gap: 1rem; margin-top: 2rem; }}
    .card {{ display: block; padding: 1.25rem; background: #fff; border: 1px solid #ddd; border-radius: 8px; text-decoration: none; color: inherit; }}
    .card:hover {{ border-color: #4a90d9; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08); }}
    .card h2 {{ margin: 0 0 0.25rem; font-size: 1.1rem; color: #1a5fb4; }}
    .card p {{ margin: 0; color: #666; font-size: 0.9rem; }}
  </style>
</head>
<body>
  <main>
    <h1>rondemy</h1>
    <p class="subtitle">Central hub for public learning material at ronzz.org</p>
    <div class="cards">
{cards}
    </div>
  </main>
</body>
</html>
"""
    (public / "index.html").write_text(html, encoding="utf-8")
    print(f"wrote {public / 'index.html'} with {len(sites)} project(s)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
