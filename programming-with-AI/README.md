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

1. Create `chapters/<name>.qmd` (prose) or `chapters/<name>.ipynb` (code, with the `programming-with-ai` kernelspec).
2. Add it to `_quarto.yml` → `website.sidebar.contents`.
3. Verify with `quarto render`.

## Agent instructions

See `AGENTS.md` in this directory and the [root `AGENTS.md`](../AGENTS.md).
