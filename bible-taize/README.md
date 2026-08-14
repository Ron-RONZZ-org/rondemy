# Bible & Taizé

Media and resources for Taizé chants and prayer programmes, plus Bible meditation notes. Built with [Quarto](https://quarto.org) (website project).

- **Chants** — recordings of Taizé chants (`chants/`: `.mp3`, `.mkv`, `.gif`), listed on `chapters/chants.qmd`.
- **Programmes** — prayer programme sheets (`programmes/`: `.pdf`), listed on `chapters/programmes.qmd`.
- **Méditations bibliques** — Bible meditation notes in French (e.g. `chapters/jas-2-fr.qmd`).
- Rendered output is a static site in `_site/` with sidebar navigation and search.

## Structure

```
bible-taize/
├── _quarto.yml            # site config: title, sidebar, search, theme
├── index.qmd              # home page
├── chapters/              # content pages (.qmd)
│   ├── jas-2-fr.qmd       # Bible meditation: Jacques 2
│   ├── chants.qmd         # chant recordings index
│   └── programmes.qmd     # programme PDFs index
├── chants/                # chant media files (passthrough to _site/)
└── programmes/            # programme PDFs (passthrough to _site/)
```

## Build & preview

```shell
# Render the site
quarto render

# Live preview with reload
quarto preview
```

Output lands in `_site/` (gitignored).

## Adding a page

Each page is one file in `chapters/`, and the site navigation is generated **only** from `_quarto.yml` → `website.sidebar.contents`. Quarto does not scan the folder: a file that exists but is not listed in the sidebar still renders an HTML page, but it has no link from the site navigation (it becomes an orphan page). So every page requires **two** steps:

1. **Create the file** — `chapters/<name>.qmd` with YAML frontmatter (`title:`).
2. **Register it in the sidebar** — add it to `website.sidebar.contents` in `_quarto.yml`.

## Adding media

Drop files into `chants/` or `programmes/`, then add links on the corresponding chapter page. Filenames contain spaces and non-ASCII characters — use CommonMark angle-bracket destinations or raw HTML in links:

```markdown
[mp3](<../chants/Aber du weißt den Weg für mich.mp3>)
```

## Deployment

Published automatically by the repo CI ([`.github/workflows/publish.yml`](../.github/workflows/publish.yml)) on push to `main`: <https://ron-ronzz-org.github.io/rondemy/bible-taize/>.

## Agent instructions

See `AGENTS.md` in this directory and the [root `AGENTS.md`](../AGENTS.md).
