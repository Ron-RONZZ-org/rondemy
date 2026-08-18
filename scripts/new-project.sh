#!/usr/bin/env bash
# Scaffold a new rondemy Quarto website project.
#
# Creates <name>/ containing everything a new sub-project needs:
#   _quarto.yml      site config with navbar home button, search, docked sidebar
#   index.qmd        home page
#   chapters/        home.qmd plus a chapter-template.qmd reference page
#   README.md        build/preview instructions
#   AGENTS.md        module agent instructions
#   .gitignore       ignores Quarto build output
#
# It also adds the project to the root README.md Projects table.
# CI discovers projects automatically (any top-level dir with _quarto.yml),
# so no workflow or landing-page edits are needed. The site will be published
# at https://rondemy.ronzz.org/<name>/ on the next push to main.
#
# Usage: scripts/new-project.sh <name> [--title "Title"] [--description "Desc"] [--dry-run]
set -euo pipefail

NAME=""
TITLE=""
DESCRIPTION=""
DRY_RUN=0

usage() {
  sed -n '/^# Scaffold/,/^# Usage:/p' "$0" | sed 's/^# \{0,1\}//'
  echo
  echo "Options:"
  echo "  --title \"Title\"         Site title (default: title-cased name)"
  echo "  --description \"Desc\"    Site description (default: placeholder)"
  echo "  --dry-run               Print what would be created without writing"
  echo "  -h, --help              Show this help"
}

die() {
  echo "error: $*" >&2
  exit 1
}

# --- option parsing -------------------------------------------------------

while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    --title) [ $# -ge 2 ] || die "--title requires an argument"; TITLE="$2"; shift 2 ;;
    --description) [ $# -ge 2 ] || die "--description requires an argument"; DESCRIPTION="$2"; shift 2 ;;
    --dry-run) DRY_RUN=1; shift ;;
    -*) die "unknown option: $1 (see --help)" ;;
    *) [ -z "$NAME" ] || die "unexpected extra argument: $1 (see --help)"; NAME="$1"; shift ;;
  esac
done

# --- validation -----------------------------------------------------------

[ -n "$NAME" ] || die "missing project name (see --help)"

case "$NAME" in
  *[!a-z0-9-]*|--*|*-) die "invalid name '$NAME': use lowercase kebab-case, e.g. 'my-project'" ;;
esac

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
[ -d .github ] && [ -f README.md ] || die "run from the repo root (or via scripts/new-project.sh)"
[ -f "$NAME/_quarto.yml" ] && die "project '$NAME' already exists"

if [ -z "$TITLE" ]; then
  TITLE="$(printf '%s' "$NAME" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)} 1')"
fi
[ -z "$DESCRIPTION" ] && DESCRIPTION="Educational project: $TITLE."

echo "Scaffolding project '$NAME' in $(pwd)/$NAME/"
echo "  title:       $TITLE"
echo "  description: $DESCRIPTION"
echo "  dry-run:     $([ "$DRY_RUN" -eq 1 ] && echo yes || echo no)"
echo

write_file() {
  local path="$1"
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "  would create $path"
    return
  fi
  echo "$2" > "$path"
  echo "  created $path"
}

mkdir_tree() {
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "  would create directory $1"
  else
    mkdir -p "$1"
  fi
}

# --- file generation ------------------------------------------------------

mkdir_tree "$NAME/chapters"

write_file "$NAME/_quarto.yml" "project:
  type: website

website:
  title: \"$TITLE\"
  description: \"$DESCRIPTION\"
  search: true
  navbar:
    right:
      - icon: house-fill
        href: https://rondemy.ronzz.org/
        text: \"rondemy home\"
  sidebar:
    style: \"docked\"
    contents:
      - chapters/home.qmd
      - section: \"Content\"
        contents:
          - chapters/chapter-template.qmd

format:
  html:
    theme: cosmo
    toc: true
"

write_file "$NAME/index.qmd" "---
title: \"$TITLE\"
author: \"Rong Zhou\"
description: \"$DESCRIPTION\"
---

Welcome to $TITLE.
"

write_file "$NAME/chapters/home.qmd" "---
title: \"Home\"
---

Welcome. Add an overview here; put detailed chapters under the \"Content\"
section in the sidebar (\`_quarto.yml\` → \`website.sidebar.contents\`).
"

# chapter-template.qmd is a living reference showing the .qmd format. It is
# written with a quoted heredoc so backticks, quotes and $ are taken literally.
chapter_template=$(cat <<'EOF'
---
title: "Chapter Template"
description: "A worked example of the .qmd format: frontmatter options, prose, lists, tables, code blocks and callouts."
author: "Rong Zhou"
date: today
lang: en
categories:
  - reference
  - template
tags:
  - quarto
  - markdown
toc: true
format:
  html:
    toc: true
    code-fold: true
---

This file is a living template for writing chapters. Copy it to `chapters/<slug>.qmd`, then add it to the sidebar in `_quarto.yml`. It shows the main pieces of the `.qmd` format.

## Frontmatter

The block between the `---` lines at the top is YAML frontmatter. It sets page metadata (`title`, `author`, `date`, `lang`, `categories`, `tags`) and per-page format options (here `toc` and collapsible code blocks via `code-fold`). Anything set in the project's `_quarto.yml` is inherited unless overridden here.

## Prose

Write Markdown normally: **bold**, *italic*, `inline code`, and links like [Quarto websites](https://quarto.org/docs/websites/).

### Sub-heading

Headings become entries in the table of contents (`toc: true`). Use `##` for major sections and `###` for sub-sections.

## Lists

- unordered item
- another item
  - a nested item

1. ordered item
2. second ordered item

## Blockquote

> A blockquote is useful for citations or highlighted passages. Preserve quotes and source links verbatim.

## Table

| Feature | Purpose |
|---|---|
| Prose | body text |
| Code block | runnable or illustrative code |
| Callout | emphasize a note or warning |

## Code block

```python
def greet(name: str) -> str:
    return f"Hello, {name}!"

print(greet("Quarto"))
```

Because `code-fold: true` is set in the frontmatter, this code block is collapsible in the rendered page.

## Callout

::: {.callout-note}
This is a Quarto callout. Use `{.callout-note}`, `{.callout-tip}`, `{.callout-warning}`, or `{.callout-important}`.
:::
EOF
)
write_file "$NAME/chapters/chapter-template.qmd" "$chapter_template"

write_file "$NAME/README.md" "# $TITLE

$DESCRIPTION

## Build

- \`quarto render\` — render the site to \`_site/\`
- \`quarto preview\` — local dev server with live reload

## Deployment

Pushed to \`main\`, CI renders this project and publishes it at
<https://rondemy.ronzz.org/$NAME/> (see the root README).
"

write_file "$NAME/AGENTS.md" "# AGENTS.md — $NAME Agent Instructions

## Summary

A Quarto website project within the rondemy collection, configured by
\`_quarto.yml\` (navbar home button, search, docked sidebar, \`cosmo\` theme,
per-page TOC). Rendered to a static site in \`_site/\`.

## Purpose and Expected Behavior

- \`index.qmd\` is the home page. Content pages live in \`chapters/\`.
- CI discovers the project automatically (top-level dir with \`_quarto.yml\`)
  and publishes it at <https://rondemy.ronzz.org/$NAME/>.

## Constraints and Invariants

- **Every page must be listed in \`_quarto.yml\` → \`website.sidebar.contents\`.**
- **Never commit build artifacts**: \`_site/\`, \`.quarto/\` (gitignored).
- **The navbar home button must link to <https://rondemy.ronzz.org/>** — it is
  the parent landing page for all rondemy projects.

## Input/Output Expectations

- **Source**: \`_quarto.yml\`, \`index.qmd\`, \`chapters/*.qmd\`.
- **Output**: \`quarto render\` produces \`_site/index.html\` and
  \`_site/chapters/<slug>.html\` plus search index and site libs.
- **Preview**: \`quarto preview\` serves the site locally with live reload.

## Documentation Reference

- Quarto: https://quarto.org/docs/ (websites: https://quarto.org/docs/websites/)
- Project root conventions: see \`../AGENTS.md\` (root rules apply unless overridden here).

## Domain-Specific Rules for Agents

- **Adding a page**: create \`chapters/<name>.qmd\` with YAML frontmatter
  (\`title:\`), then add it to the sidebar in \`_quarto.yml\`.
- **Verification before commit**: \`quarto render\` must succeed with no errors;
  then check \`_site/\` — sidebar lists all pages and links resolve.
- **CI publishing**: on push to \`main\`, the root \`publish.yml\` renders this
  project and deploys it to <https://rondemy.ronzz.org/$NAME/>.
"

write_file "$NAME/.gitignore" "# Quarto build output
_site/
.quarto/

/.quarto/
"

# --- root README ----------------------------------------------------------

update_readme() {
  # Add the new project as a row in the root README Projects table.
  local row="| [$NAME]($NAME/) | $DESCRIPTION | \`quarto render\` |"
  if grep -q "^| \[$NAME\]($NAME/)" README.md; then
    echo "  README.md: '$NAME' already listed"
    return
  fi

  # Locate the Projects table by its header row, then take the LAST row of that
  # table only. A Markdown table is contiguous: every row starts with '|' and
  # the table ends at the first non-'|' line. Scoping to the header keeps us
  # safe even if other tables are added later in the file.
  local last_line
  last_line="$(awk '
    /^\| *Project *\| *Description *\| *Build *\|/ { hdr = NR }
    hdr && /^\|/ { last = NR }
    hdr && !/^\|/ && last { exit }
    END { print last }
  ' README.md)"

  if [ -z "$last_line" ]; then
    echo "  warning: no Projects table found in README.md — add '$NAME' to the Projects table manually" >&2
    return
  fi
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "  would update README.md: $row"
    return
  fi
  sed -i "${last_line}a $row" README.md
  echo "  updated README.md (added '$NAME' to the Projects table)"
}

update_readme

# --- summary --------------------------------------------------------------

echo
if [ "$DRY_RUN" -eq 1 ]; then
  echo "Dry run complete — nothing was written."
else
  echo "Done. Next steps:"
  echo "  cd $NAME && quarto render   # verify the skeleton builds"
  echo "  Commit and push — CI publishes to https://rondemy.ronzz.org/$NAME/"
fi
