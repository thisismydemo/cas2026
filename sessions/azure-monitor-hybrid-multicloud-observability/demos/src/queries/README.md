# Query desk

Run the queries in your Log Analytics workspace (the presenter's lab used `law-tplabs-cas26-shared-eus-01`), in the Logs blade or with `az monitor log-analytics query --workspace <workspace GUID>`. They are written to the **stage-record schema** of the telemetry contract in the lab design: `TimeGenerated`, `CorrelationId`, `OrderNumber`, `Customer`, `Environment`, `Cloud`, `Origin`, `Component`, `Stage`, `Success`, `DurationMs`, `DemoTag`, `FailureMode`, `Computer`.

The [rehearsal captures](../fixtures/README.md) show the result shape each order query returns, for use when a live query is slow on stage.

| File | Question it answers | Replace before running | How to read it |
|---|---|---|---|
| [order-journey.kql](order-journey.kql) | What happened to this one order, stage by stage and cloud by cloud? | `<CORRELATION_ID>` (the GUID, not the order number) | Expect seven rows for a completed order: `Accepted`, `Dispatched`, two `Started`, two worker `Completed`, then the coordinator's `Completed`. A missing row is missing evidence or a stuck stage, not success. |
| [service-outcome.kql](service-outcome.kql) | Did orders complete? | nothing (window 30 minutes) | Rows are summarized **by `CorrelationId` first**, so one order counts once however many stages it has. `Outcome` is `Failed` if any row failed, `Completed` only with the coordinator's `Completed` row, otherwise `Unresolved`. A commented roll-up gives service totals. |
| [evidence-freshness.kql](evidence-freshness.kql) | When did each route last deliver: Heartbeat and Perf for each Arc-connected AWS machine, and each stage of the order records? | `<AWS_RESOURCE_GROUP>` | `AgeMin` against `ExpectedMaxAgeMin` gives `Fresh` or `Stale`. The expected ages are presenter settings (see the comments). A source that is silent for the whole window does not appear at all: compare against the machines you expect. |
| [telemetry-volume.kql](telemetry-volume.kql) | Which tables drive billable ingestion? | nothing | GB per table over 30 full days, from the `Usage` table (`Quantity` is MB). Workspace ingestion only; not a full bill. |
| [stage-record-volume.kql](stage-record-volume.kql) | What does the order evidence cost per order? | nothing | Rows and billed bytes per order from `_BilledSize`; about seven rows per completed order. |

For a blank result check, in order: tenant and workspace, time range, the placeholder value, the DCR and its association (or, for stage records, the direct-ingestion DCR `dcr-cas26-requests-eus-01` and its stream), ingestion delay. Do not remove scope filters to get rows.

References: [Log queries](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-query-overview), [Usage table](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/usage), [Analyze usage](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/analyze-usage), [Standard columns](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-standard-columns).

## Environment queries (not run on stage)

These build or verify the lab environment. Terraform (`shared/foundation/terraform/modules/health` and `alerting`) and `shared/foundation/scripts/Ensure-Cas26AzureHealthModel.ps1` / `Ensure-Cas26AzureSessionExperience.ps1` read them from this folder at apply time. The Hybrid Operations session keeps its own copy of `health-failure.kql` for its H16 demo; change both together.

| File | Role | Consumed by |
| --- | --- | --- |
| `health-failure.kql` | Health model signal `request-failure-percent` — failed orders as a percentage of resolved orders (by `CorrelationId`), with a three-order minimum-sample gate | `terraform/modules/health` at apply time |
| `health-coverage.kql` | Health model signal `telemetry-coverage` — orders seen in the window (`Samples`). Pairs with the failure signal so silence is visible rather than read as success; no rows returns nothing, so the signal is Unknown | `terraform/modules/health` at apply time |
| `health-guest-cpu.promql` | Health model signal — guest CPU busy percent from the **metrics** plane | `terraform/modules/health` at apply time |
| `alert-service-failure.kql` | Alert rule body — service-centric, fires once for the service when at least three orders resolved in five minutes and half or more failed | `terraform/modules/alerting` at apply time |
| `alert-guest-cpu.kql` | Alert rule body — per-computer resource alert | `terraform/modules/alerting` at apply time |
| `alert-agent-missing.kql` | Alert rule body — guests silent for fifteen minutes | `terraform/modules/alerting` at apply time |
| `syslog.kql` | **Build verification** — is rsyslog/imfile → AMA → DCR working? | A human, during setup |
| `probeEvents.kql` | **Build verification** — are correlated request outcomes reaching `Cas26Service_CL`? | A human, during setup |

An empty result is never proof the environment is healthy:

| File | Empty means |
| --- | --- |
| `syslog.kql` | Check rsyslog imfile setup, facility, AMA integration and the DCR |
| `probeEvents.kql` | Check the application, forwarding, and the table schema |
| `health-failure.kql` | Fewer than three resolved orders deliberately suppresses the failure calculation (signal Unknown) — that is the gate, not a fault |
| `health-coverage.kql` | No stage records in five minutes (signal Unknown); a value below three means insufficient recent evidence (Unhealthy) |

### Notes that affect the deployment

The custom service table schema is defined in `terraform/modules/foundation/main.tf`. `modules/collection` supplies the direct-ingestion DCR and grants the session identity Monitoring Metrics Publisher on it. `modules/metrics` builds the Azure Monitor workspace and the OpenTelemetry rule, and grants the health model identity Monitoring Data Reader on that workspace — without which the PromQL signal cannot be attached.

IIC Hybrid Orders forwards one `CorrelationId` through the serving Azure-or-AWS portal origin, the Azure coordinator (`Coordinator`), Service Bus (`Transport`), on-premises validation (`OnPremWorker`) and AWS fulfillment (`AwsWorker`). Signal and alert queries group by that ID so multiple stage records do not double-count an order. Exactly as in `service-outcome.kql`, an order is complete only when the coordinator writes `Component=Coordinator`, `Stage=Completed`, `Success=true`, and any `Success=false` row (including a `TimedOut` or `DeadLettered` stage) fails it. Keep per-stage rows in `probeEvents.kql` for investigation—batching and replay can still increase ingestion volume even when the signals deduplicate.

`cas26-` name filters and `Project=cas26` tags are teaching scope filters, not an authorization boundary.

Sources: [Health Models signals](https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/signals), [AMA overview](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview).
