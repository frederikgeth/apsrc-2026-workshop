# APSRC Open-Source Energy System Modelling Workshop: program

Quarto source for the program of the Open-Source Energy System Modelling
Workshop at the 2026 Asia-Pacific Solar Research Conference (APSRC): a web page
plus PDFs, all built from one markdown file per talk.

Website: <https://openenergymodelling-au.github.io/apsrc-2026-workshop/>

## Build

```sh
quarto render                # web page + both PDFs -> _site/
quarto render schedule.qmd   # just the one-page schedule PDF
quarto preview               # live preview in the browser while editing
```

Requires Quarto ≥ 1.11 (bundles Typst 0.15) and the Satoshi font (see [Fonts](#fonts)).

## Outputs

All in `_site/` (ignored by git):

| File | Contents |
|------|----------|
| `index.html` | Web: schedule page (header, PDF downloads, schedule) |
| `talks.html` | Web: talks page (all abstracts, with links between sessions) |
| `program.pdf` | Schedule, then details of every talk |
| `schedule.pdf` | One-page schedule only |

## Where things live

| Path | What to edit there |
|------|--------------------|
| `schedule.yml` | Event details (title, date, venue, logos), the running order of sessions, and the session folders |
| `talks/panel-session/` | One file per panel-session presentation, named after the speaker |
| `talks/lightning-session/` | One file per ‘short-circuit’ (lightning) talk, named after the speaker |
| `talks/_template.md` | Copy this to add a talk |
| `index.qmd`, `talks.qmd` | The two web pages |
| `program.qmd` | Page order of the full program PDF |
| `_quarto.yml` | Website settings (title, navigation bar, footer) and build options |
| `theme/web.scss` | Web page fonts, colours and layout |
| `theme/theme-apsrc.typ` | PDF fonts, colours, sizes |
| `theme/layout.typ` | How the PDF schedule and talk details are arranged |
| `filters/program.lua` | Reads `schedule.yml` and `talks/` and builds the header, schedule and talk details for both the web page and PDFs |
| `fonts/` | Where the Satoshi font files go (see below) |

## Adding a talk

1. Copy `talks/_template.md` into the right session folder, named after the
   speaker, e.g. `talks/lightning-session/jane-smith.md`. The folder decides
   which session the talk appears in.
2. Fill in `order`, `title`, `speakers` and optional `links`.
3. Write the abstract below the `---` line.
4. `quarto render`. The talk appears in both the schedule and the talk details.

In the schedule, speakers show as "Name (affiliation-short)". The talk details
show "Honorific Name, affiliation". If `affiliation-short` is missing, the full
affiliation is used in both places.

To add a new session folder, create it under `talks/` and list it under
`talk-folders` in `schedule.yml` (with its heading), then point a session at it
with `talks: <folder>`.

## Publishing to GitHub Pages

The site is built on your machine (where Satoshi is installed, so the PDFs come
out right) and pushed to the `gh-pages` branch, which GitHub Pages serves:

```sh
quarto publish gh-pages
```

The first time, this creates the `gh-pages` branch and a `_publish.yml` file
(commit that). Then in the repo's **Settings → Pages**, set the source to
**Deploy from a branch**, branch `gh-pages`, folder `/ (root)`.

Push source changes to `main` as usual (`git push origin main`); publishing is
a separate step. Avoid `git push --all`.

## Changing the look

- **Fonts, colours, sizes:** edit the values in `theme/theme-apsrc.typ`. The
  theme matches the conference website: Satoshi, royal blue `#0000A8` and the
  website's greys.
- **Another theme:** copy `theme/theme-apsrc.typ` to `theme/theme-<name>.typ`,
  change its values, and set `program-theme: <name>` in `_quarto.yml`.

## Fonts

The theme uses **Satoshi**, the font of the conference website. It's free to
use, including embedded in PDFs and on websites, but its licence doesn't allow
sharing the font files, so they're not in this repository.

1. Download Satoshi from <https://www.fontshare.com/fonts/satoshi>.
2. Put the `.otf` files in `fonts/satoshi/` (ignored by git).

Without Satoshi the PDF still builds, but in Typst's built-in serif font.

To list the fonts Typst can see: `quarto typst fonts --font-path fonts`.

## Notes

- **Draft notice:** while `draft-notice:` is set in `schedule.yml`, a banner
  appears on the web pages and above the PDF schedule, and PDF pages carry a
  faint "DRAFT" watermark. Delete that line once the program is final.
- `::: {.todo}` blocks in a `.qmd` file render as highlighted "To do" boxes, to mark placeholders.
- The talk files are plain markdown with YAML front matter, so a website can reuse them later.
