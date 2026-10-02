# Telemetry measurement worksheet

Use this worksheet to measure the effect of a telemetry reduction (M05). Fill it from live queries over comparable windows; never substitute example values for a measurement.

| Measurement | Baseline window | Changed window |
| --- | --- | --- |
| UTC start and end | Record | Record |
| Workspace and included tables | Record privately | Same scope or explain difference |
| Request count and request rate | Record | Record |
| Collected events and sampling | Baseline DCR revision | Changed DCR revision |
| Billable GB | Query Usage for complete days | Same query and duration |
| Incident evidence retained | List required events | Confirm still present |
| Query and alert usefulness | Owner's assessment | Owner's assessment |

Use `(baseline volume - changed volume) / baseline volume` only when baseline volume is nonzero and the windows are comparable. Report negative results honestly. GB reduction is not automatically equal to monetary savings; pricing tiers, commitments, retention, query charges and Sentinel billing can affect the result.

Capture source timestamp, first query visibility, first model state change and first alert separately. Record application recovery time independently from monitoring recovery. Keep test request rate stable while measuring.
