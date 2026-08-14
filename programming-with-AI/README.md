# Computer Programming with AI

A web-first textbook on computer programming in the era of AI, built with [Quarto](https://quarto.org) (website project).

- **Prose chapters** are `.qmd` files (definitions, quotes, citations).
- **Code chapters** are executable `.ipynb` Jupyter notebooks, run at render time.
- Rendered output is a static site in `_site/` with sidebar navigation and search.

## Structure

```
programming-with-AI/
├── _quarto.yml            # site config: title, sidebar, search, theme
├── index.qmd              # home page
├── chapters/
│   ├── defining-ai.qmd    # prose chapter
│   └── ...                # future code chapters as .ipynb
├── images/                # media used by chapters
└── .venv/                 # Python env with Jupyter (for notebook execution)
```

## Setup

```shell
uv venv .venv
uv pip install --python .venv/bin/python jupyter
.venv/bin/python -m ipykernel install --user --name programming-with-ai
```

## Build & preview

```shell
# Render the site (venv must be on PATH so Quarto finds Jupyter)
PATH=.venv/bin:$PATH quarto render

# Re-execute a single notebook chapter
PATH=.venv/bin:$PATH quarto render chapters/<name>.ipynb --execute

# Live preview with reload
PATH=.venv/bin:$PATH quarto preview
```

Output lands in `_site/` (gitignored).

## Adding a chapter

Each chapter (or subchapter) is one file in `chapters/`, and the site navigation is generated **only** from `_quarto.yml` → `website.sidebar.contents`. Quarto does not scan the folder: a file that exists but is not listed in the sidebar still renders an HTML page, but it has no link from the site navigation (it becomes an orphan page). So every chapter requires **two** steps:

1. **Create the file** — `chapters/<name>.qmd` (prose) or `chapters/<name>.ipynb` (code, with the `programming-with-ai` kernelspec, executed at render time).
2. **Register it in the sidebar** — add it to `website.sidebar.contents` in `_quarto.yml`.

Example — a flat chapter:

```yaml
website:
  sidebar:
    style: "docked"
    contents:
      - section: "Introduction"
        contents:
          - chapters/defining-ai.qmd
```

### Subchapters (chapters regrouping multiple qmd)

Yes — subchapters are just nested sidebar sections. Each subchapter is its own `.qmd` file; a "chapter" is a `section` group containing them. Sections nest at any depth.

```yaml
website:
  sidebar:
    style: "docked"
    contents:
      - section: "Introduction"
        contents:
          - chapters/defining-ai.qmd

      - section: "Prompting"
        contents:
          - section: "Basics"
            contents:
              - chapters/prompt-basics.qmd
              - chapters/prompt-patterns.qmd
          - section: "Advanced"
            contents:
              - chapters/prompt-advanced.qmd
```

This renders a sidebar with `Prompting → Basics → (Prompt Basics, Prompt Patterns)` and `Advanced → Prompt Advanced`. There is no depth limit.

> **Sidebar vs. on-page TOC:** the sidebar (from `_quarto.yml`) expresses the chapter/subchapter hierarchy; the on-page TOC (from `format.html.toc: true`) lists the `##`/`###` headings *within* a single page. Both exist independently.

### Verification

```shell
PATH=.venv/bin:$PATH quarto render
```

Then check in `_site/`: the sidebar lists the new chapter, search finds it, and for notebooks the code cells produced output.

## Deployment

Published automatically by the repo CI ([`.github/workflows/publish.yml`](../.github/workflows/publish.yml)) on push to `main`: <https://ron-ronzz-org.github.io/rondemy/programming-with-AI/>. The CI installs Jupyter and renders with the `programming-with-ai` kernel, so notebook chapters execute on every deploy.

## Agent instructions

See `AGENTS.md` in this directory and the [root `AGENTS.md`](../AGENTS.md).
