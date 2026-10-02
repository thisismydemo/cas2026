# Attendee handouts

Two handouts support the Hybrid Operations session. Start with the companion to understand and apply the operating model; keep the desk playbook for daily decisions. The Markdown files are the editable sources; the matching PDFs are formatted for sharing and printing.

| Handout | Editable source | Printable PDF |
|---|---|---|
| Session companion: why hybrid needs an operating model (the four questions across five estates), the example application, then the five sections and their questions (Observe, Secure, Govern, Cost, Adopt the patterns), each opening with a plain answer and followed by diagrams from the deck, tenant checks, decisions and Microsoft Learn references. Covers agent + DCR collection and "green servers, broken service"; the four access doors, Defender for Cloud and Sentinel; landing zones, the Azure Arc landing zone network paths, Azure Policy compared with Group Policy and machine configuration, compliance without Purview, Update Manager and ESUs, and Flux; Arc costs, the cost levers and log transformations; letting the system fix things and the playbook (what to adopt, what to unlearn, your first thirty days). Appendix A covers Arc onboarding: connecting a server, SCVMM and vCenter, the multicloud connector for AWS and GCP, EC2 versus EKS, edge and legacy. Also query patterns, a service operating contract and a glossary | [Markdown](session-companion.md) | [PDF](session-companion.pdf) |
| Desk playbook: two-page card with one practice, owner, next action and evidence per section, the three key rules and four access doors, where to ask each question, the levels of letting the system fix things, what to unlearn and the first thirty days | [Markdown](hybrid-operations-playbook.md) | [PDF](hybrid-operations-playbook.pdf) |

Both are written for readers who did not attend and do not have the presenter's lab. Examples use the fictional IIC Hybrid Orders application, which the companion describes in full. Commands and queries use placeholders and state the schema or scope they need; no output is presented as an observed tenant result. Reviewed September 30, 2026; verify current support, previews, plans and prices before implementation.

For slide-by-slide explanations use the [attendee notes](../presentation/attendee-notes.md). For the demonstrated procedures use the [demo runbooks](../demos/README.md).

## Regenerating

The PDFs were generated from the Markdown sources; the generators are not part of this repository. The companion's diagrams in `assets/` were cropped from the deck. The generators used the Python packages `pillow`, `markdown`, `beautifulsoup4` and `reportlab`.
