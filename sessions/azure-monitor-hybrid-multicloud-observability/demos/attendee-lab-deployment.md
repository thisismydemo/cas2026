# Attendee lab deployment guide

This guide helps you rebuild the session's pattern in your own subscription. The repository gives you the design, the monitoring foundation code, the demo queries, the helper scripts and the rehearsal captures. It does not give you anyone's credentials, tenant or account IDs, or access to the CAS26 environment.

## What the session demonstrates

The design of record is the CAS26 multi-cloud application and health-model design. It keeps three planes apart:

1. **Order path (application).** Public DNS, then Azure Front Door and WAF, then a portal origin in Azure Container Apps or on AWS (ALB to EKS), then an Azure Functions coordinator and Azure Service Bus, then two required workers: on-premises validation and AWS fulfillment. The coordinator assigns one correlation ID, and the order completes only when both workers succeed.
2. **Management (Azure Arc).** The AWS and on-premises machines are Arc-connected so they can be governed and can carry the Azure Monitor Agent. Arc does not carry orders.
3. **Evidence.** Guest telemetry travels AMA, a DCR association and a DCR into Log Analytics; the application's stage records travel the Logs Ingestion API through a direct DCR (no association) into `Cas26Service_CL`; metrics go to an Azure Monitor workspace. Azure Monitor Health Models evaluates health from that evidence, and a workbook provides the drill-down.

## What you can reuse

| Part | Where it is | How to use it |
|---|---|---|
| Monitoring foundation: Log Analytics, Azure Monitor workspace, DCRs, custom table, alerts, workbook, Health Model | shared/foundation/terraform | Adapt it: the Terraform is written for the CAS26 lab, so replace names, subscriptions and identities with your own. |
| Arc onboarding of AWS machines through the Multicloud connector | Portal and connector documentation | Use your own AWS account and Azure subscription. See [Onboard multicloud VMs](https://learn.microsoft.com/en-us/azure/azure-arc/multicloud-connector/onboard-multicloud-vms-arc). |
| IIC Hybrid Orders application (Front Door, portal origins, coordinator, Service Bus, both workers) | Specified in the lab design: topology, telemetry contract and worker fault contract | Build your own equivalent to the same contracts; the queries and helpers then work unchanged. |
| Order client and fault helper | [demos/scripts](scripts/README.md) | Point them at your own application if it follows the documented order endpoint and state-file contract. |
| Queries | [src/queries](src/queries/README.md) | Run them against a table with the telemetry contract columns. |
| Rehearsal captures | [src/fixtures](src/fixtures/README.md) | Use them to learn how to read each result; they are CAS26 captures, not results from your tenant. |

## Suggested sequence in your environment

1. Pick an Azure subscription, a Log Analytics workspace and resource group you own. Keep identifiers in a private file, never in source.
2. Create the custom table and a direct DCR with the telemetry contract columns (`TimeGenerated`, `CorrelationId`, `OrderNumber`, `Customer`, `Environment`, `Cloud`, `Origin`, `Component`, `Stage`, `Success`, `DurationMs`, `DemoTag`, `FailureMode`, `Computer`). See [Logs Ingestion API](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview).
3. Arc-enable one AWS machine and one on-premises machine, install AMA, and associate a guest DCR. Prove each route with the M01 steps before building anything on top.
4. Build a minimal two-worker application: a coordinator that assigns a correlation ID and writes one stage record per stage, and two workers that read a CAS26-style state file and write their own stage records. Authenticate with managed identities (Arc system-assigned identity for the workers), not stored secrets.
5. Place an order and read it with [order-journey.kql](src/queries/order-journey.kql) and [service-outcome.kql](src/queries/service-outcome.kql).
6. Build the Health Model from the commitment down (Customers can complete an order, then each required branch), with Log Analytics signals on the stage records, `WorstOf` aggregation and missing data producing Unknown. See [Health models concepts](https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/concepts).
7. Run a bounded fault only against your own worker's application mode, with an expiry; then prove recovery with a new order. A successful reset command is not recovery.
8. Check freshness and cost with [evidence-freshness.kql](src/queries/evidence-freshness.kql) and [telemetry-volume.kql](src/queries/telemetry-volume.kql), and record any reduction together with the question it gives up.

## Evidence and safety

Keep a dated record of each command, its target, the expected and the observed result, and its limitation. Stop when the identity, scope or evidence does not match the intended target. Never fault shared infrastructure: no stopping hosts, agents, clusters, load balancers or network paths. Treat sample IDs, timestamps and fixtures in these materials as examples, not as evidence from your tenant. Health Models is in preview; check its current regions and API versions before you start.
