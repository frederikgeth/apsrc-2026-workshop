---
# Copy this file into the session folder for the talk, named after the
# speaker, e.g. talks/lightning-session-1/jane-smith.md
# (the folder decides the session; files starting with "_" are ignored).

order: 99                # position within its session (lower = earlier)
# tbc: true              # optional: shows "(TBC)" after the title until confirmed

title: "Talk title goes here"   # keep the quotes if the title contains a colon

authors:                 # in author order; the presenter is shown in the schedule
  - name: Firstname Lastname
    presenter: true                       # who presents (only needed with co-authors;
                                          # otherwise the first author presents)
    honorific: Dr                         # optional: Dr, A/Prof, Prof ... (talk details,
                                          # single-author talks only)
    affiliation: Full Organisation Name   # shown in talk details
    affiliation-short: FON                # optional: shown in the schedule instead
  - name: Co-author Name                  # optional co-authors: delete if none
    affiliation: Their Organisation

links:                   # optional: delete this whole section if there are none
  - label: Repository
    url: https://github.com/org/repo
  - label: Documentation
    url: https://example.org/docs
---

The abstract goes here, as ordinary markdown (leave it empty and the program
shows "Abstract to come."). Separate paragraphs with a
blank line. *Emphasis*, **bold** and [links](https://example.org) all work.
