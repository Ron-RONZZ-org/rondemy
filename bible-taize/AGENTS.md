# AGENTS.md — bible-taize Agent Instructions

## Summary
Media and resources for Taizé chants and prayer programmes, plus Bible meditation notes. Built with Quarto (website project) since 2026-08-13. Rendered to a static site in `_site/`.

## Purpose and Expected Behavior
- The site is a Quarto **website** project configured by `_quarto.yml` (title, docked sidebar, search, `cosmo` theme, per-page TOC).
- `index.qmd` is the home page. Content pages live in `chapters/`.
- **Content directories** (kept as-is, passthrough to `_site/`):
  - `chants/` — chant recordings (`.mp3`, `.mkv`, `.gif`).
  - `programmes/` — prayer programme sheets (`.pdf`).
- Quarto copies these static assets into `_site/` on render; pages link to them with relative paths (`../chants/...`, `../programmes/...`).

## Constraints and Invariants
- **Every page must be listed in `_quarto.yml` → `website.sidebar.contents`.** Unlisted pages are rendered but not part of the published site navigation.
- **Never commit build artifacts**: `_site/`, `.quarto/` (gitignored).
- **Preserve citations verbatim** — Bible verses and their source links are content, not lintable prose.
- **Chant/programme filenames contain spaces and non-ASCII characters** (German `ä ü ß`, French accents and `’`). Link to them with CommonMark angle-bracket destinations, e.g. `[mp3](<../chants/Aber du weißt den Weg für mich.mp3>)`, or raw HTML. Do not rename files casually — existing names match their recorded titles; a rename is a deliberate content change.
- **One content language**: chant titles are German/French as recorded; Bible notes are French (`lang: fr`). Site navigation labels are French.

## Input/Output Expectations
- **Source**: `_quarto.yml`, `index.qmd`, `chapters/*.qmd`, `chants/`, `programmes/`.
- **Output**: `quarto render` produces `_site/index.html`, `_site/chapters/<slug>.html`, and passes `chants/` + `programmes/` through to `_site/`.
- **Preview**: `quarto preview` serves the site locally with live reload.
- No Python/Jupyter environment needed (no executable chapters).

## Documentation Reference
- Quarto: https://quarto.org/docs/ (websites: https://quarto.org/docs/websites/)
- Project root conventions: see `../AGENTS.md` (root rules apply unless overridden here).

## Domain-Specific Rules for Agents
- **Adding a page**: create `chapters/<name>.qmd` with YAML frontmatter (`title:`), then add it to the sidebar in `_quarto.yml`.
- **Adding media**: drop files into `chants/` or `programmes/`, then add links on the corresponding chapter page.
- **Verification before commit**: `quarto render` must succeed with no errors; then check `_site/` — sidebar lists all pages, media links resolve (`../chants/...`), and audio players load.
- **CI publishing**: on push to `main`, `.github/workflows/publish.yml` renders this project and deploys it to GitHub Pages at `https://ron-ronzz-org.github.io/rondemy/bible-taize/`.
