# AGENTS.md — programming-with-AI Agent Instructions

## Summary
A web-first textbook on computer programming in the era of AI, built with Quarto (website project). Prose chapters are `.qmd` files; code chapters are executable `.ipynb` notebooks. Rendered to a static site in `_site/`.

## Purpose and Expected Behavior
- The site is a Quarto **website** project configured by `_quarto.yml` (title, docked sidebar, search, `cosmo` theme, per-page TOC).
- `index.qmd` is the home page. Chapters live in `chapters/`.
- Chapters are either:
  - **`.qmd`** — prose-only content (definitions, quotes, citations). Example: `chapters/defining-ai.qmd`.
  - **`.ipynb`** — executable notebook content (code cells, outputs, charts). Executed at render time with `--execute`.
- Both file types coexist in the same `chapters/` folder and the same sidebar.

## Constraints and Invariants
- **Every chapter must be listed in `_quarto.yml` → `website.sidebar.contents`.** Unlisted chapters are rendered but not part of the published site navigation.
- **`.venv/` must contain the full `jupyter` package**, not just `ipykernel` — Quarto fails with "Jupyter is not available in this Python installation" otherwise. Installed via `uv pip install --python .venv/bin/python jupyter`.
- **The venv must be on `PATH` when rendering** so Quarto finds the Jupyter kernel:
  ```shell
  PATH=.venv/bin:$PATH quarto render
  ```
- Notebook chapters should declare `kernelspec` matching the registered kernel (`programming-with-ai`, installed via `.venv/bin/python -m ipykernel install --user --name programming-with-ai`).
- Never commit build artifacts: `_site/`, `.quarto/`, `.venv/` (gitignored).
- Do not reintroduce Quarkdown syntax (`.docname`, `.include {docs}`, `.qd` files) — the project migrated to Quarto on 2026-08-12.

## Input/Output Expectations
- **Source**: `_quarto.yml`, `index.qmd`, `chapters/*.qmd`, `chapters/*.ipynb`, `images/`.
- **Output**: `quarto render` produces `_site/index.html`, `_site/chapters/<slug>.html`, plus search index and site libs.
- **Preview**: `quarto preview` serves the site locally with live reload.

## Documentation Reference
- Quarto: https://quarto.org/docs/ (websites: https://quarto.org/docs/websites/)
- Project root conventions: see `../AGENTS.md` (root rules apply unless overridden here).

## Domain-Specific Rules for Agents
- **Adding a prose chapter**: create `chapters/<name>.qmd` with YAML frontmatter (`title:`), then add it to the sidebar in `_quarto.yml`.
- **Adding a code chapter**: create `chapters/<name>.ipynb` with the `programming-with-ai` kernelspec, then add it to the sidebar.
- **Verification before commit**:
  1. `PATH=.venv/bin:$PATH quarto render` — must succeed with no errors.
  2. For changed notebooks: `PATH=.venv/bin:$PATH quarto render chapters/<name>.ipynb --execute` — cells must run and outputs appear.
  3. Visual check of `_site/`: sidebar lists all chapters, search works, headings render.
- **CI publishing**: on push to `main`, `.github/workflows/publish.yml` renders this project (with Jupyter installed and the `programming-with-ai` kernel registered) and deploys it to GitHub Pages at `https://ron-ronzz-org.github.io/rondemy/programming-with-AI/`.
- **Citation content is sacred**: preserve quotes and source links verbatim (mixed English/French is intentional).
- **Python environment**: only install packages needed to execute notebook chapters; prefer stdlib/well-known libraries.
