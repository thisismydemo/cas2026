# Presentation

The storyboard [`outline/storyboard.md`](outline/storyboard.md) is the source of truth for the 44-slide deck: one row per slide with its ID, title, visual, explanation and evidence status. [`dual-notes.json`](dual-notes.json) holds the hand-written speaker notes, attendee notes and sources for every slide ID.

The build and export scripts are not part of this repository.

## Decks

| File | What it is |
|---|---|
| [`decks/azure-monitor-hybrid-multicloud-observability-casnavy.pptx`](decks/azure-monitor-hybrid-multicloud-observability-casnavy.pptx) | Speaker deck, 44 slides, CAS Navy, DEMO slides hidden |
| [`decks/azure-monitor-hybrid-multicloud-observability-attendee-casnavy.pptx`](decks/azure-monitor-hybrid-multicloud-observability-attendee-casnavy.pptx) | Attendee deck, the same 44 slides, DEMO slides visible |
| [`decks/observability-multicloud-reference/`](decks/observability-multicloud-reference/storyboard.md) | "Observability across clouds", an 87-slide reference deck (graphite and amber), independent of the session and the lab, with its own `storyboard.md` |

Also in this folder: `session-content.json` (the generated slide manifest; do not edit by hand), [`speaker-notes.md`](speaker-notes.md) and [`attendee-notes.md`](attendee-notes.md) (readable exports of the notes), [`assets/`](assets/) (the images used on slides: presenter, meeting illustrations, feedback QR code, sponsor tile) and [`references/sources.md`](references/sources.md) (the sources cited in the notes).

Speaker notes for every slide are KEY POINTS (short scannable bullets, also stored as `keyPoints`), then TALKING POINTS, then PURPOSE.

Every session slide is drawn as native, editable PowerPoint shapes in the CAS Navy palette. The sponsor, contact, recommendations and Questions slides were taken from the presenter's earlier Monitoring deck and re-coloured to the same palette; the About Me slide is a full-slide image. Demo slides carry the full-height DEMO marker.

The build enforced a formatting gate: no text colour outside the palette, no text below 11 pt, no text contrast below 4.5:1 and no text overflowing its shape.

To change a slide, edit its storyboard row and its `dual-notes.json` entry.
