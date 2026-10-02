# Preparation and rehearsal

Owner: presenter / shared lab operator. The demos run against IIC Hybrid Orders as built from the lab design. Resource existence alone does not pass a demo: each one passes when its rehearsal produces the expected evidence.

## What the demos use

| What | Used by |
|---|---|
| Log Analytics workspace `law-tplabs-cas26-shared-eus-01` and Azure Monitor workspace `amw-tplabs-cas26-shared-eus-01` (management subscription, RG `rg-tplabs-cas26-mon-eus-01`) | All |
| DCRs `dcr-tplabs-cas26-linux-eus-01`, `dcr-tplabs-cas26-windows-eus-01`, `dcr-tplabs-cas26-otel-eus-01` and the direct-ingestion `dcr-cas26-requests-eus-01` | M01, M05 |
| The six IIC EC2 machines, Arc-connected through the multicloud connector (RG `aws_<AWS account ID>` in the Arc workload subscription), and the EKS connected cluster | M01, M03, M05 |
| IIC Hybrid Orders: Front Door with the Azure Container Apps and AWS ALB -> EKS portal origins, the Functions coordinator `func-tplabs-cas26-iic-eus-01`, Service Bus `sb-tplabs-cas26-iic-eus-01`, the on-premises validation worker on `cas26-lnx01` (SCVMM Hyper-V cluster) and the AWS fulfillment worker on `iic-cas26-prd-api-01` | M02, M03 |
| `Cas26Service_CL` with the telemetry-contract columns | M01-M05 |
| Workbook "CAS26 service operations" | M02 |
| Health Model `hm-tplabs-cas26-service-cus-01` (Central US): IIC Hybrid Orders, its three commitments and their components | M03, M04 |
| Alert rule "CAS26 service: request failures" (5-minute window and frequency, stateful) | M03 |

## Pre-delivery checks

1. `config/demo.local.json` filled with verified identifiers, including `ServiceUrl`, `FrontDoorProfileResourceId`, `WorkbookResourceId`, `AwsWorkerInstanceId` and `AwsWorkerArcResourceId`; the context loader passes with `-Offline` and then against the current Azure context.
2. On the presenter jump: Azure CLI with the `log-analytics` and `resource-graph` extensions; AWS CLI signed in with `ssm:SendCommand` and `ssm:GetCommandInvocation` on the AWS worker instance only; PowerShell 7.
3. Both portal origins healthy in Front Door; both workers in `Healthy` mode (`Set-Cas26WorkerMode.ps1 -Mode Healthy -InstanceId ... -DryRun`).
4. Rehearse the order client and the fault helper end to end: `Invoke-Cas26Request.ps1 -WhatIf`, then real demo-tagged orders; `Set-Cas26WorkerMode.ps1 -Mode Fail -InstanceId ... -DryRun`, then `Fail` and `Healthy`. See [the scripts README](scripts/README.md) for the order endpoint and response shape.
5. Read the model's signal queries once (M04 steps 4 and 7): they summarize by `CorrelationId` and use the contract completion rule, the same as [service-outcome.kql](src/queries/service-outcome.kql).

## Rehearsal record

For each demo keep, under `evidence/local/` (gitignored): the date and time (UTC), the identity used, the command, the target, the observed result and its limitation. The [evidence README](evidence/README.md) has the format. Record the measured clocks for M03: order time, ingestion delay, model state change, alert fired and resolved.

## On the day

- Light theme in the portal and the terminal.
- Tabs open: workbook, Health Model graph, Logs blade on the workspace, presenter terminal with `$Demo` loaded.
- AWS worker in `Healthy` (check with `-DryRun`) before M02; again after M03 stage 2 before leaving.
