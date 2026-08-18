# rondemy

A personal collection of educational projects.

## Projects

| Project | Description | Build |
|---|---|---|
| [programming-with-AI](programming-with-AI/) | Web-first textbook on programming in the era of AI (Quarto + Jupyter notebooks) | `quarto render` |
| [bible-taize](bible-taize/) | Taizé chants and programmes (PDFs, audio/video) | `quarto render` |
| [vie-en-france](vie-en-france/) | Un guide pratique pour des personnes immigrées vivant en France | `quarto render` |

## Deployment

A GitHub Actions workflow ([`.github/workflows/publish.yml`](.github/workflows/publish.yml)) renders both sites and publishes them to GitHub Pages on every push to `main`:

- <https://ron-ronzz-org.github.io/rondemy/> — landing page (auto-lists all projects)
- <https://ron-ronzz-org.github.io/rondemy/programming-with-AI/>
- <https://ron-ronzz-org.github.io/rondemy/bible-taize/>

GitHub Pages serves one site per repo, so both projects live at subpaths. The landing page is regenerated on each deploy and picks up new project folders automatically. A manual re-publish is available under **Actions → Publish to GitHub Pages → Run workflow**.

## Adding a new project

Scaffold a new Quarto website project with:

```shell
scripts/new-project.sh <name> --title "..." --description "..."
```

This creates `<name>/` with the standard site config (navbar home button back to `https://rondemy.ronzz.org/`, search, docked sidebar), a home page, a `chapters/home.qmd` page, and a `chapters/chapter-template.qmd` reference showing the `.qmd` format, plus `README.md` and `AGENTS.md`, and adds the project to the table above. CI discovers projects automatically — any top-level directory with a `_quarto.yml` is rendered and published — so no workflow or landing-page edits are needed; the next push to `main` publishes the site at `https://rondemy.ronzz.org/<name>/`. Use `--dry-run` to preview.

## Agent instructions

See `AGENTS.md` at the repo root and in each project directory.
