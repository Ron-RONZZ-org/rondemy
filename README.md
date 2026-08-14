# rondemy

A personal collection of educational projects.

## Projects

| Project | Description | Build |
|---|---|---|
| [programming-with-AI](programming-with-AI/) | Web-first textbook on programming in the era of AI (Quarto + Jupyter notebooks) | `quarto render` |
| [bible-taize](bible-taize/) | Taizé chants and programmes (PDFs, audio/video) | `quarto render` |

## Deployment

A GitHub Actions workflow ([`.github/workflows/publish.yml`](.github/workflows/publish.yml)) renders both sites and publishes them to GitHub Pages on every push to `main`:

- <https://ron-ronzz-org.github.io/rondemy/> — landing page (auto-lists all projects)
- <https://ron-ronzz-org.github.io/rondemy/programming-with-AI/>
- <https://ron-ronzz-org.github.io/rondemy/bible-taize/>

GitHub Pages serves one site per repo, so both projects live at subpaths. The landing page is regenerated on each deploy and picks up new project folders automatically. A manual re-publish is available under **Actions → Publish to GitHub Pages → Run workflow**.

## Agent instructions

See `AGENTS.md` at the repo root and in each project directory.
