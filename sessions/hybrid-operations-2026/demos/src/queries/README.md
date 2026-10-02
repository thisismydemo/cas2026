# Query desk

Replace `REPLACE_WITH_*` literals with the identifiers from `demo.local.json` before running. Keep local resolved copies outside source control.

| File | Run in | Question / limit |
|---|---|---|
| inventory.arg.kql | Azure Resource Graph Explorer | Which Arc representations are in our two landing scopes? Connection state does not prove guest monitoring or customer health. |
| policy-state.arg.kql | Azure Resource Graph Explorer | What did the exact assignment last report for this resource? State can lag remediation. |
| heartbeat.kql | Log Analytics workspace Logs | When did this machine last send an agent heartbeat? Empty output means no matching evidence in this scope/window. |
| service-overview.kql | Log Analytics workspace Logs | Did IIC orders complete? Summarizes the per-stage rows by CorrelationId, then counts completed, failed and unresolved orders; inspect order count and evidence age. |
| sentinel-incidents.kql | Sentinel workspace Logs | What is the latest recorded state of our labelled training incidents? Confirm the incident in the portal too. |
| telemetry-volume.kql | Log Analytics workspace Logs | Which tables contribute billable ingestion Mbytes? Workspace total, not a machine bill or complete cost model. |

`sessions/hybrid-operations-2026/demos/src/queries/sentinel-training-event.kql` checks the harmless event before incident creation. `sessions/hybrid-operations-2026/demos/src/queries/performance.kql` is the optional guest CPU view; adjust its Computer filter to the rehearsed machines. PromQL goes to an Azure Monitor workspace; these KQL files do not.

For blank results, first check tenant, workspace, resource/Computer identifier, time range, DCR association, destination and ingestion delay. Do not remove scope filters merely to get rows. See [Usage table schema](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/usage) and [Resource Graph overview](https://learn.microsoft.com/en-us/azure/governance/resource-graph/overview).

## Environment queries (not run on stage)

These build or verify the lab environment. `sentinel-training-event.kql` is read by Terraform (`shared/foundation/terraform/modules/security`) and `shared/foundation/scripts/Ensure-Cas26AzureSessionExperience.ps1`. `health-failure.kql` is a copy of the Observability session's signal query, used by the H16 demo; the lab deploys from the Observability copy, so change both together.

| File | Role | Consumed by |
| --- | --- | --- |
| `health-failure.kql` | Health model signal — percentage of completed or failed IIC production orders that failed, with a minimum-sample gate; keyed on the telemetry contract (`Component == 'Coordinator'`, `Stage == 'Completed'`, `Success == true`) | `terraform/modules/health` at apply time |
| `sentinel-training-event.kql` | Sentinel analytics rule body — the explicit CAS26Demo training marker | `terraform/modules/security` at apply time |
| `events.kql` | **Build verification** — is the Windows Event pipeline collecting? | A human, during setup |
| `performance.kql` | **Build verification** — are Windows perf counters landing? | A human, during setup |

An empty result is never proof the environment is healthy:

| File | Empty means |
| --- | --- |
| `events.kql` | Check the event source, the DCR, the association and ingestion |
| `performance.kql` | Verify matching counter names and collection. Linux differs from Windows |
| `health-failure.kql` | Fewer than three samples deliberately suppresses the failure calculation — that is the gate, not a fault |
| `sentinel-training-event.kql` | No marker was written. **This is not a security finding.** |
