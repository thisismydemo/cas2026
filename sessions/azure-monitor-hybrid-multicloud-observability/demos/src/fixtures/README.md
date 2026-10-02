# Rehearsal captures

These files hold the results the demos produce, in the exact shape of the telemetry contract in the lab design. They are the live-demo contingency: if a query, an ingestion delay or the portal is slow on stage, show the matching capture, say that it is the captured result from rehearsal, and name the step it stands in for.

| File | Used by | What it shows |
|---|---|---|
| [order-baseline.jsonl](order-baseline.jsonl) | M01, M02 stage 1, M04 | Order `IIC-000042` (correlation ID `7d0c4242-1a42-4c42-9a42-000000000042`), served by the Azure origin: seven stage rows across `Azure`, `OnPrem` and `AWS`, ending with `Coordinator` / `Completed` / `Success=true`. |
| [order-marvin.jsonl](order-marvin.jsonl) | M03 stage 1 | Order `IIC-000043` (`...000000000043`), served by the AWS origin, placed while the AWS worker is in `Fail` mode: `AwsWorker` / `Failed` / `FailureMode=marvin`, the on-premises stage still completes, and the coordinator fails the order. |
| [order-recovery.jsonl](order-recovery.jsonl) | M03 stage 2 | Order `IIC-000044` (`...000000000044`), a new order after the reset: every stage completes and the order completes. A new correlation ID is the point. |
| [heartbeat-aws-worker.jsonl](heartbeat-aws-worker.jsonl) | M03 stage 1 | Minute-by-minute `Heartbeat` for the AWS worker machine `iic-cas26-prd-api-01` from 15:15 to 15:35 UTC, covering the fault window: the machine stays fresh while the order fails. Resource IDs are placeholders. |
| [usage-by-table.jsonl](usage-by-table.jsonl) | M05 | The result shape of [telemetry-volume.kql](../queries/telemetry-volume.kql): `DataType` and `BillableGB` over 30 full days, ordered by volume. The quantities are examples of the shape; quote cost figures only from the live query. |

## Shape

The three order files hold one JSON object per line with exactly the contract columns: `TimeGenerated`, `CorrelationId`, `OrderNumber`, `Customer`, `Environment`, `Cloud`, `Origin`, `Component`, `Stage`, `Success`, `DurationMs`, `DemoTag`, `FailureMode`, `Computer`. `Origin` is set only on the coordinator's `Accepted` row. `Computer` uses the application's resource names (`func-tplabs-cas26-iic-eus-01`, `sb-tplabs-cas26-iic-eus-01`) and the worker host names (`cas26-lnx01` on-premises, `iic-cas26-prd-api-01` on AWS).

Correlation IDs are GUIDs, as the contract requires; the 42 theme lives in the order numbers and the last digits of each GUID. All capture times are on 2026-09-26 UTC.

## Replay

```powershell
pwsh ./sessions/azure-monitor-hybrid-multicloud-observability/demos/scripts/Show-Cas26Fixture.ps1 -Path ./sessions/azure-monitor-hybrid-multicloud-observability/demos/src/fixtures/order-marvin.jsonl
```

The script prints a banner naming the capture, the stage journey and the order outcome, using the same rule as [service-outcome.kql](../queries/service-outcome.kql): any `Success=false` row fails the order; otherwise it is complete only with the coordinator's `Completed` row.

Newer captures made with `-JsonLinesPath` go under `demos/evidence/local/` (gitignored).
