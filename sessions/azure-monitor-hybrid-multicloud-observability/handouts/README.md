# Attendee handouts

Two handouts support the Whole-Service Observability session. Start with the companion to understand the architecture and the ideas; keep the field manual for the worksheets, queries and checklist you actually fill in and run. The Markdown files are the editable sources; the matching PDFs are formatted for sharing and printing.

| Handout | Editable source | Printable PDF |
|---|---|---|
| Session companion: what "working" means, the three-cloud architecture, evidence routes and identity, correlation, the service view, Health Models, alerts and the four clocks, cost, and the operating cycle, with a glossary - the *understand this* document | [Markdown](session-companion.md) | [PDF](session-companion.pdf) |
| Observability Field Manual: five paired worksheet-and-query sections (define working, evidence routes, investigation and freshness, health model design, cost) plus the one-page design checklist - the *do this* document | [Markdown](observability-field-manual.md) | [PDF](observability-field-manual.pdf) |

Both are written for readers who did not attend and do not have the presenter's lab. Examples use the fictional IIC Hybrid Orders application (Infinite Improbability Corp, real Azure, AWS and on-premises services), which the companion describes. Commands and queries use placeholders and state the schema or scope they need; no output is presented as an observed tenant result. Azure Monitor health models are in preview. Reviewed September 26, 2026; verify current support, previews, plans and prices before implementation.

Each Field Manual worksheet is paired with the queries that verify it, in the same section, instead of separated into disconnected appendices - so neither the worksheet nor the queries make sense without flipping to a different document to finish the thought.

For slide-by-slide explanations use the [attendee notes](../presentation/attendee-notes.md). For the demonstrated procedures use the [demo runbooks](../demos/README.md). The application's design of record is `lab/design/HYBRID-APPLICATION-HEALTH-DESIGN.md` in the session repository.

## Regenerating

The PDFs were generated from the Markdown sources; the generators are not part of this repository. The companion's diagrams in `assets/` were cropped from the deck. The generators used the Python packages `pillow`, `markdown`, `beautifulsoup4` and `reportlab`.
