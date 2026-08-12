# AGENTS.md — Root Project Rules for rondemy

This is the canonical, repo-wide instruction file for AI agents working on **rondemy**.

## Hierarchical Context Model

Agents **must** follow this rule:

> When working inside a directory, load the nearest `AGENTS.md` file and merge it with parent `AGENTS.md` files up to root.
> Local rules override global rules.

Context resolution order (highest priority first):
1. `AGENTS.md` in module directories — module-specific context (e.g. `programming-with-AI/AGENTS.md`)
2. Root `AGENTS.md` — global project rules

---
## Project Overview

**rondemy** is a personal collection of educational projects. It currently hosts:

- **`programming-with-AI/`** — a web-first textbook on computer programming in the era of AI, built with [Quarto](https://quarto.org). Prose chapters are `.qmd`; code chapters are executable `.ipynb` notebooks. See `programming-with-AI/AGENTS.md`.
- **`bible-taize/`** — media and resources for Taizé chants and programmes (PDFs, audio/video). No build system; content files only.

The two projects are independent: no shared code, dependencies, or tooling.

---

## Language and Naming Conventions

- Comments, commit messages, and documentation in English. (Content of the textbook itself is intentionally mixed English/French citations.)
- File names: `kebab-case` (e.g. `defining-ai.qmd`, `_quarto.yml`).
- Chapters live under `chapters/` in each project.

---

## Tech Stack

| Project | Tooling |
|---|---|
| `programming-with-AI` | Quarto 1.6.42 (website project), Python 3.12/3.13 via `uv`, Jupyter (`.venv`) |
| `bible-taize` | None (media files) |

## Dependency management

- `programming-with-AI` uses `uv` for the Python environment (`.venv/`). Install/update:
  ```shell
  uv venv .venv
  uv pip install --python .venv/bin/python jupyter
  ```
- **Do not install new packages without a reason** — the environment exists solely to execute notebook chapters.
- `bible-taize` has no dependencies.

## Coding Guidelines

1. **Prose chapters are `.qmd`, executable chapters are `.ipynb`** — never put runnable code in a `.qmd` unless it is a short illustration; notebooks are the execution vehicle.
2. **Every chapter must be listed in the sidebar** — add it to the `sidebar.contents` of `_quarto.yml` (unlisted pages are not part of the published site).
3. **YAML frontmatter only in Quarto files** (`---` blocks with `title:`, `author:`, etc.). Quarkdown function-call syntax (`.docname`, `.include {docs}`) is legacy — do not reintroduce it.
4. **Preserve citations verbatim** — quotes and their source links (Oxford dictionary, Wikipedia, arXiv) are textbook content, not lintable prose.

## Documentation Standards

- **Every module must have a corresponding `AGENTS.md` file.**
- **Every module should have a `README.md`** describing how to build/preview it.
- Update docs in the same commit as the structural change they describe.

---

## Commit Message Format

Use [Conventional Commits](https://www.conventionalcommits.org/):
- `feat:`, `fix:`, `docs:`, `chore:`, `test:`, `refactor:`

---

## Testing Requirements

This repo contains no automated tests: `programming-with-AI` is a static documentation site and `bible-taize` is media content.

Verification substitutes:
- **Build check**: `quarto render` must succeed with no errors before committing changes to `programming-with-AI`.
- **Notebook execution**: run `quarto render --execute` on any changed notebook chapter to confirm cells run.
- Manual visual check of `_site/` (sidebar links, search, headings) for layout-sensitive changes.

---

## What to Avoid

- Do not reintroduce Quarkdown syntax or files (the project migrated to Quarto on 2026-08-12).
- Do not commit build artifacts: `_site/`, `.quarto/`, `.venv/`, `quarkdown-output/` (see `.gitignore`).
- Do not modify `bible-taize/` when working on `programming-with-AI` and vice versa.

---

## Module-Level AGENTS Files

| Module | AGENTS File | Build/Preview |
|---|---|---|
| `programming-with-AI` | `programming-with-AI/AGENTS.md` | `quarto render` / `quarto preview` |
| `bible-taize` | *(none — content only)* | n/a |

(Update this table as new modules are added)

---

## Dependency and Inheritance Map

```
Root AGENTS.md (global rules)
    │
    ├── programming-with-AI/AGENTS.md (local rules, override root)
    └── bible-taize/ (no AGENTS.md — root rules apply)
```

Local rules override global rules. Module-level files focus on domain-specific behavior, constraints, and invariants.
