# CAS26 request service

> **Local test fixture only.** Neither CAS26 deck nor demo uses this endpoint-to-worker service; both use IIC Hybrid Orders. See lab/design/HYBRID-APPLICATION-HEALTH-DESIGN.md, including its Demo helper contract, which `Invoke-Cas26Request.ps1` and `Set-Cas26WorkerMode.ps1` implement. This folder remains only as a local test fixture.

A deliberately small service makes liveness, successful requests and monitored health distinguishable. It binds to loopback by default, has no remote fault-control endpoint, and writes one structured JSON line per request. It is the local fallback/test fixture, not the target IIC Hybrid Orders distributed application and not a production application.

From the repository root with Node 24 and PowerShell 7:

```powershell
$env:CAS26_WORKER_STATE = Join-Path ([IO.Path]::GetTempPath()) 'cas26/worker-state.json'
$env:CAS26_LOG_PATH = Join-Path ([IO.Path]::GetTempPath()) 'cas26/service.jsonl'
$env:CAS26_SERVICE_URL = 'http://127.0.0.1:4310'
node sessions/hybrid-operations-2026/demos/src/sample-service/server.mjs
```

In another terminal, set the same environment variables and run the request, fault and repair steps below. `Set-Cas26WorkerMode.ps1` changes only the named CAS26 state file. `/healthz` remains live during a controlled application failure; `/request` returns 503 during failure and 200 after repair. Request IDs are unique. JSONL output goes to `CAS26_LOG_PATH`.

To model a split endpoint/worker locally, run a second instance with a different `CAS26_PORT`, state path and log path. Set the front instance's `CAS26_WORKER_URL` to the worker URL. The front endpoint calls the worker with a five-second timeout.

The target observability scenario is defined in `lab/design/HYBRID-APPLICATION-HEALTH-DESIGN.md`: Azure Front Door/WAF routes to redundant Azure Container Apps and AWS ALB/EKS portal origins, and Azure Functions/Service Bus coordinates required AWS and on-premises stages. This sample's direct relay mode is not the cross-cloud transport and is not shown in either session.

On real hosts the service is installed by `cloud-init.yaml` in this folder: it writes `server.mjs` to `/opt/cas26`, a systemd unit that binds to all interfaces on the configured port, and an rsyslog `imfile` input that forwards the JSONL log on `local0` for the Linux collection rule ([rsyslog-cas26.conf.example](rsyslog-cas26.conf.example) shows the same input on its own). The [kubernetes/](kubernetes/kustomization.yaml) folder holds the Kustomization and ConfigMap that Flux applies in the EKS demo. Terraform renders the file for the Azure endpoint (worker URL set) and the AWS guest (standalone worker); `New-Cas26LabVm.ps1` renders it into a NoCloud seed disk for the lab worker, and `Install-Cas26Worker.ps1` applies it over SSH when the template has no cloud-init. The remote worker's state file is `/var/lib/cas26/worker-state.json`, switched with `Set-Cas26WorkerMode.ps1 -SshTarget user@host`.

Run `node --test sessions/hybrid-operations-2026/demos/src/sample-service/server.test.mjs` for local failure/recovery and telemetry-contract tests. `request-capture.test.mjs` tests the request capture of `Invoke-Cas26Request.ps1 -JsonLinesPath`. Stopping the server does not remove logs or state.
