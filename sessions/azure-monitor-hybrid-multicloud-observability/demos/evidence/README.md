# Demo evidence

Dated rehearsal and delivery captures go in `evidence/local/` next to this file. That folder is gitignored: it may contain tenant-specific identifiers and must never contain credentials or tokens.

One Markdown or JSON file per demo run, named `<demo>-<yyyyMMdd-HHmm>.md` (for example `m03-20261001-1420.md`), with:

| Field | Example |
|---|---|
| Observed at (UTC) | 2026-10-01T14:20:05Z |
| Identity | presenter account in the CAS26 tenant |
| Demo and step | M03 step 3 |
| Command or portal path | `Invoke-Cas26Request.ps1 -BaseUri ... -DemoTag` |
| Target | Front Door endpoint; AWS worker instance |
| Observed result | `Status=Failed`, `FailureMode=marvin`, correlation ID |
| Limitation | Model state change not observed before the next slide |

`Invoke-Cas26Request.ps1 -JsonLinesPath` writes order results here as JSON lines. A capture is evidence only for its date, and so are the [rehearsal captures](../src/fixtures/README.md) kept with the queries.
