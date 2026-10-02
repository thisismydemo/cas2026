# Demo operating scripts

| Script | What it does |
|---|---|
| `Invoke-Cas26Request.ps1` | Place IIC Hybrid Orders through the Front Door endpoint; returns one result per order (correlation ID, origin, status, per-stage results) and can capture JSON lines |
| `Set-Cas26WorkerMode.ps1` | Set one worker's CAS26 fault mode (`Healthy`, `Delay`, `Fail`, `Pause`) with automatic expiry; `-Mode Healthy` is the reset |
| `Enter-DemoContext.ps1` | Validates the configuration and Azure CLI context, sets `$Demo` |
| `Show-Cas26Fixture.ps1` | Replays a rehearsal capture with a banner and the order outcome |
| `Send-Cas26Telemetry.ps1` | Upload captured rows to the selected Logs Ingestion stream (retired sample-service format) |

Use the appropriate session runbook for target checks, expected results, evidence and reset. These are deliberate actions against the selected demo resources. For creating resources, onboarding or sign-in, use foundation scripts.

## Contract

The first two scripts implement the *Demo helper contract* and *Worker fault contract* in the lab design. Both sessions call them by name; keep the names, parameters and return fields stable.

### `Invoke-Cas26Request.ps1`

| Parameter | Meaning |
|---|---|
| `-BaseUri` | Front Door endpoint (required). A URI with user information, or a query string carrying `code`, `key`, `sig`, `token` or similar, is rejected. |
| `-Count` | 1-100 orders, default 1 |
| `-IntervalSeconds` | 0-60, default 1 |
| `-DemoTag` | Marks the order so worker fault modes apply to it |
| `-JsonLinesPath` | Optional capture: one compact JSON result per order |
| `-OrderPath` | Default `/api/orders` (see the order endpoint below) |
| `-TimeoutSeconds` | 5-300, default 60; a longer wait is reported as `TimedOut` |
| `-WhatIf` | Print the request that would be sent; nothing is sent |

Returns one object per order: `CorrelationId`, `RequestId` (alias of `CorrelationId`, kept for older runbooks), `OrderNumber`, `Origin`, `Status` (`Completed`, `Failed` or `TimedOut`), `Success`, `ElapsedMs`, `FailureMode`, `DemoTag`, `Stages` (each with `Cloud`, `Component`, `Stage`, `Success`, `DurationMs`), `HttpStatus`, `PlacedAtUtc`.

**The order endpoint.** The script uses `POST {BaseUri}/api/orders` with the JSON body `{"customer":"IIC","item":"Towel (Standard Issue)","quantity":42,"demoTag":<bool>,"clientRequestId":"<guid>"}`, and accepts either a synchronous final result or HTTP 202 with a `Location` header on the same host, polled until the order is final. The response must carry `correlationId` and a `status` from the contract; otherwise the script fails rather than reporting success. Stage values outside the telemetry contract produce a warning. If the deployed path or response shape ever changes, update the script header, this README and the lab design together.

No credential, token or key is read, sent or printed.

### `Set-Cas26WorkerMode.ps1`

| Parameter | Meaning |
|---|---|
| `-Mode` | `Healthy` (reset), `Delay` (fault `deep-thought`), `Fail` (fault `marvin`), `Pause` (fault `vogon`) |
| `-DelaySeconds` | Only with `Delay`; 1-30, default 8 |
| `-MaxMinutes` | Writes `expires_at`; 1-60, default 15; ignored for `Healthy` |
| `-SshTarget` | On-premises worker (`user@host`), over SSH; optional `-SshKeyPath` |
| `-InstanceId` | AWS worker EC2 instance, over AWS Systems Manager Run Command; optional `-AwsRegion`, `-AwsProfile` |
| `-StatePath` | Local file, for local worker tests only |
| `-DryRun` | Read the current state (read-only) and print the proposed file without writing |

Name exactly one target. The script writes only `/var/lib/cas26/worker-state.json` (or `-StatePath`), refuses a file that is not `"project":"cas26"`, records the previous mode in the file's `previous` key and in its output (`PreviousMode`, `Changed`), and is idempotent. `Healthy` succeeds when the file is missing. It never stops a service, VM or host. It exits non-zero on failure, so `pwsh ./sessions/azure-monitor-hybrid-multicloud-observability/demos/scripts/Set-Cas26WorkerMode.ps1 ...; if ($LASTEXITCODE -ne 0) { ... }` works as the Hybrid runbooks expect. SSH and SSM both need `sudo -n` rights for the state directory on the worker.
