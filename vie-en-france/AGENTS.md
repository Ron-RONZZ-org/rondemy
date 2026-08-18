# AGENTS.md — vie-en-france Agent Instructions

## Summary

A Quarto website project within the rondemy collection, configured by
`_quarto.yml` (navbar home button, search, docked sidebar, `cosmo` theme,
per-page TOC). Rendered to a static site in `_site/`.

## Purpose and Expected Behavior

- `index.qmd` is the home page. Content pages live in `chapters/`.
- CI discovers the project automatically (top-level dir with `_quarto.yml`)
  and publishes it at <https://rondemy.ronzz.org/vie-en-france/>.

## Constraints and Invariants

- **Every page must be listed in `_quarto.yml` → `website.sidebar.contents`.**
- **Never commit build artifacts**: `_site/`, `.quarto/` (gitignored).
- **The navbar home button must link to <https://rondemy.ronzz.org/>** — it is
  the parent landing page for all rondemy projects.

## Input/Output Expectations

- **Source**: `_quarto.yml`, `index.qmd`, `chapters/*.qmd`.
- **Output**: `quarto render` produces `_site/index.html` and
  `_site/chapters/<slug>.html` plus search index and site libs.
- **Preview**: `quarto preview` serves the site locally with live reload.

## Documentation Reference

- Quarto: https://quarto.org/docs/ (websites: https://quarto.org/docs/websites/)
- Project root conventions: see `../AGENTS.md` (root rules apply unless overridden here).

## Domain-Specific Rules for Agents

- **Adding a page**: create `chapters/<name>.qmd` with YAML frontmatter
  (`title:`), then add it to the sidebar in `_quarto.yml`.
- **Verification before commit**: `quarto render` must succeed with no errors;
  then check `_site/` — sidebar lists all pages and links resolve.
- **CI publishing**: on push to `main`, the root `publish.yml` renders this
  project and deploys it to <https://rondemy.ronzz.org/vie-en-france/>.

