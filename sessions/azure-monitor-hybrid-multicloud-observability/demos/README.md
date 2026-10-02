# Whole-Service Observability — demo desk

Open [demo-console.html](demo-console.html) for delivery. It runs offline, walks through every step, copies commands, and shows expected evidence, troubleshooting, speaker explanations and attendee takeaways. It does not run commands or connect to Azure. The printable [runbooks](runbooks/) hold the same steps.

The lab was torn down on 2 October 2026. Commands need your own environment; to follow the demos without one, use the rehearsal captures in [src/fixtures/](src/fixtures/README.md).

All five demos follow one application, **IIC Hybrid Orders**, as specified in the lab design: one order with one correlation ID crosses Azure (Front Door, coordinator, Service Bus), the on-premises worker and the AWS worker, and every stage writes a record to `Cas26Service_CL`.

## Demo sequence

| Slides | ID | Demo |
|---|---|---|
| 16 | [M01](runbooks/m01.md) | Prove each evidence route: DCR associations, Heartbeat and Perf for the Arc-connected AWS machines, and the direct-ingestion route for the order stage records |
| 20 (stage 1), 21 (stage 2) | [M02](runbooks/m02.md) | Place a baseline order and read the service view |
| 23 (stage 1), 34 (stage 2) | [M03](runbooks/m03.md) | Follow the controlled fault (`marvin` on the AWS worker `iic-cas26-prd-api-01`), then prove recovery with a fresh order |
| 29 (stage 1), 30 (stage 2) | [M04](runbooks/m04.md) | Inspect the model configuration of `hm-tplabs-cas26-service-cus-01`, then explain the current state from evidence |
| 38 | [M05](runbooks/m05.md) | Test evidence freshness and cost boundaries |

The pairs 20–21, 29–30 and 23/34 are stages of one runbook. No two different runbooks are back to back in the deck.

## Start here

1. Complete [preparation.md](preparation.md).
2. From the repository root in PowerShell 7, create the private configuration once and fill verified identifiers (never commit it; it is gitignored):

```powershell
Copy-Item ./sessions/azure-monitor-hybrid-multicloud-observability/demos/config/demo.example.json ./sessions/azure-monitor-hybrid-multicloud-observability/demos/config/demo.local.json
. ./sessions/azure-monitor-hybrid-multicloud-observability/demos/scripts/Enter-DemoContext.ps1 -ConfigPath ./sessions/azure-monitor-hybrid-multicloud-observability/demos/config/demo.local.json -Offline
```

3. Sign in with the Azure CLI separately, select the monitoring or workload subscription, and load the context without `-Offline` in the presenter terminal.
4. Rehearse each runbook; keep dated captures under `demos/evidence/local/` (gitignored), as described in [evidence/README.md](evidence/README.md).

## Assets

| Path | What it is |
|---|---|
| [demo-content.json](demo-content.json) | The single source for every demo step (edit this, not the runbooks or console) |
| [runbooks/](runbooks/) | Generated printable procedures `m01.md`-`m05.md` |
| [demo-console.html](demo-console.html) | Generated offline delivery console |
| [config/demo.example.json](config/demo.example.json) | Placeholder identifiers; copy to `demo.local.json` |
| [scripts/Enter-DemoContext.ps1](scripts/Enter-DemoContext.ps1) | Validates the configuration and the Azure CLI context, sets `$Demo`; no sign-in, no writes |
| [scripts/Show-Cas26Fixture.ps1](scripts/Show-Cas26Fixture.ps1) | Replays a rehearsal capture with a banner naming it, and the order outcome |
| [src/queries/](src/queries/README.md) | Stage-schema KQL: order journey, service outcome, evidence freshness, telemetry volume, stage-record volume |
| [src/fixtures/](src/fixtures/README.md) | Rehearsal captures: baseline, `marvin` and recovery orders; AWS worker Heartbeat; usage-by-table result shape |
| [attendee-lab-deployment.md](attendee-lab-deployment.md) | How attendees can rebuild the pattern in their own subscription |
| [src/workbooks/](src/workbooks/cas26.workbook.json) | The operations workbook used in the demos |
| [telemetry-measurement.md](telemetry-measurement.md) | Telemetry volume and cost measurement for the demo estate |
| [scripts/](scripts/README.md) | Order client and worker-mode helpers (Hybrid Operations keeps its own copy) |

## Regenerate and validate

`demo-content.json` is the source for the console and runbooks. The build and export scripts are not part of this repository.

## Shared safety contract

Start with both portal origins healthy, both workers `Healthy`, verified evidence routes and a fresh baseline order. End with both workers `Healthy`, a successful new order, fresh evidence, no temporary alert suppression and no model or query change left behind.

The only change any demo makes is the AWS worker's application mode in M03, through `Set-Cas26WorkerMode.ps1` with `-MaxMinutes` as a backstop. Never stop agents, hosts, clusters, load balancers, network controllers or gateways to create a fault. Keep identifiers in private configuration and never put credentials in source, screenshots or command history. A successful management command is not customer recovery evidence. If a live query or the portal is slow, show the rehearsal capture, say so and name the step.
