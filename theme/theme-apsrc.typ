// APSRC theme: matches the 2026 APSRC conference website
// (event.fourwaves.com/2026apsrc): Satoshi font, royal-blue primary,
// neutral greys.
//
// Satoshi can't be redistributed, so it isn't in git. Download it from
// https://www.fontshare.com/fonts/satoshi and put the OTF files in
// fonts/satoshi/. Without it, Typst falls back to its built-in serif.

#let primary = rgb("#0000A8")   // website primary (hsl 240 100% 33%)
#let ink = rgb("#111827")       // website body text
#let grey = rgb("#4B5563")      // website secondary text
#let line-grey = rgb("#E5E7EB") // website borders

#let theme = (
  // Fonts
  body-font: ("Satoshi",),
  heading-font: ("Satoshi",),

  // Sizes and spacing
  body-size: 10pt,
  small-size: 8.6pt,
  meta-size: 10.5pt,
  leading: 0.62em,
  par-spacing: 0.95em,
  justify: false,
  margin: (x: 18mm, top: 16mm, bottom: 20mm),

  // Colours
  text: ink,
  muted: grey,
  accent: primary,
  link-color: primary,
  heading-color: primary,
  todo-fill: rgb("#FFF6DC"),
  draft-fill: rgb("#FFF6DC"),     // draft notice banner
  draft-stroke: rgb("#E3BD4F"),
  watermark: luma(94%),           // "DRAFT" across each page
  todo-stroke: rgb("#E3BD4F"),

  // Header
  show-kicker: true,
  kicker-size: 11pt,
  kicker-weight: 700,
  kicker-color: grey,
  header-align: left,
  title-size: 21pt,
  title-weight: 700,
  title-color: primary,
  date-weight: 700,
  header-rule: 2pt + primary,
  logo-height: 12mm,

  // Headings
  heading-weight: 700,
  h1-size: 15pt,
  h1-rule: 1pt + primary,
  h2-size: 11.5pt,

  // Schedule
  time-width: auto,   // auto = as wide as the longest time; or a fixed width like 38mm
  time-color: primary,
  time-weight: 700,
  row-pad: 7pt,
  row-rule: 0.5pt + line-grey.darken(8%),
  break-fill: rgb("#F3F4F6"),
  session-size: 10.5pt,
  session-weight: 700,
  break-weight: 500,
  session-color: ink,
  talk-weight: 500,
  talk-marker: 1.5pt + primary.lighten(55%),
  talk-list-gap: 0.55em,
  two-columns-after: 6,

  // Talk details
  talk-gap: 1.3em,
  talk-title-size: 12pt,
  talk-title-weight: 700,
  speaker-weight: 700,
  talk-rule: 0.5pt + line-grey.darken(8%),
)
