# Hybrid Operations 2026 — demo desk

Open [demo-console.html](demo-console.html) for delivery. It runs offline without a server, walks through every step, copies commands, shows evidence and troubleshooting, and includes separate speaker explanations and attendee takeaways. It does not execute commands or connect to Azure. The nine demos follow the final storyboard (64 slides) in deck order.

The lab was torn down on 2 October 2026; the steps describe the delivered demos.

**Reading this without the presenter's lab?** Each [runbook](runbooks/) opens with a plain-language "What this demo shows and why" paragraph, a "Names used in this runbook" line that explains the lab-specific names (for example `cas26-arcwin01`, `iic-cas26-dev-web-01`, `ring0-canary`), and a "To reproduce" line with generic prerequisites. Lines marked "Presenter lab" apply only to the presenter's environment. Replace the presenter's names and IDs with your own; no tenant IDs or secrets are in this repository.

Expected results describe what each step shows in the deployed environment; the rehearsal captures in `evidence/local/` are the contingency if a portal or query is slow on stage.

## Run order for delivery

Nine live demos, about 27 minutes in total. "Ready" means checked on the morning of delivery with the [pre-flight checklist](preparation.md#pre-flight-checklist-morning-of-delivery).

| Slide | Demo | Min | What must be ready |
|---|---|---|---|
| 8 | H07B — connect the on-premises/edge machines to Azure Arc | 2.5 | `cas26-arcwin01` booted and reachable from the jump; agent package pre-staged; `variables.yml` preview names only that guest; no `Owner` tag on it |
| 15 | H11 — add AWS resources through the Arc multicloud connector | 2 | Connector portal page and AWS console (CloudFormation stack) open; eight EC2 Arc machines and the EKS cluster Connected |
| 27 | H16 — query the estate, then read machine and service health | 3.5 | Resource Graph, Logs, workbook and health model tabs open; one rehearsal order visible in `Cas26Service_CL`; `ServiceUrl` and `HealthModelResourceId` populated |
| 31 | H19 — prove access to an Arc resource with Azure RBAC | 2.5 | Two terminals signed in as the reader and the operator (separate `AZURE_CONFIG_DIR`); `CAS26RbacProof` absent (or its value recorded) |
| 33 | H20A — inspect a Defender for Cloud finding for an Arc-enabled server | 3 | One Linux baseline recommendation preselected on the target machine, with its owner and window recorded |
| 35 | H20C — investigate a Microsoft Sentinel incident | 2 | Training event written on `cas26-arcwin01` before the session; `CAS26 TRAINING` incident present in the queue |
| 42 | H24 — evaluate and remediate Arc machines with Azure Policy, on-premises then AWS | 5 | Both targets NonCompliant (no `Owner` tag); both assignments `DoNotEnforce`; tags recorded |
| 47 | H23F — Update Manager across every estate | 3 | Both canaries `UpdateRing=ring0-canary` and in the ring0 dynamic scope; `$AwsCanary` set; one-time update rehearsed |
| 49 | H26 — manage the already-onboarded EKS cluster with Flux | 3.5 | `microsoft.flux` installed; branch commit recorded; `cas26-demo` configuration either absent or verified as this exercise's |

Section transitions after the demos: H16 → section 2, Secure; H20C → section 3, Govern; H24 → "What the Policy demo proved" (slide 43), then Update Manager; H26 → section 4, Cost. Section 5 is Adopt.

## Start here

1. Complete [preparation.md](preparation.md), shared with the Azure Monitor session.
2. From the repository root in PowerShell 7, copy the example once and populate verified identifiers:

```powershell
Copy-Item ./sessions/hybrid-operations-2026/demos/config/demo.example.json ./sessions/hybrid-operations-2026/demos/config/demo.local.json
pwsh ./sessions/hybrid-operations-2026/demos/scripts/Test-DemoReadiness.ps1 -ConfigPath ./sessions/hybrid-operations-2026/demos/config/demo.local.json -Offline
```

3. Sign in to the intended tenant and select the subscription separately. Run read-only checks, then load the variables for your presenter terminal:

```powershell
pwsh ./sessions/hybrid-operations-2026/demos/scripts/Test-DemoReadiness.ps1 -ConfigPath ./sessions/hybrid-operations-2026/demos/config/demo.local.json -OutputPath ./sessions/hybrid-operations-2026/demos/evidence/local/readiness.json
. ./sessions/hybrid-operations-2026/demos/scripts/Enter-DemoContext.ps1 -ConfigPath ./sessions/hybrid-operations-2026/demos/config/demo.local.json
```

4. Complete the MANUAL checks and rehearse each runbook. Use [the evidence format](evidence/README.md), then open the console.

## Demo sequence

| Slide | ID | Customer outcome | Live boundary |
|---|---|---|---|
| 8 | H07B | Connect an owned on-premises/edge guest | Individual guest onboarding (`cas26-arcwin01`); connected edge |
| 15 | H11 | Discover AWS resources and distinguish onboarding states | Connector and mapped source identities: eight EC2 Arc machines (six IIC application servers, two SQL Server machines) and the EKS cluster, all Connected |
| 27 | H16 | Answer inventory and operating-health questions | Resource Graph, freshness, one IIC order and the Health Model |
| 31 | H19 | Prove access with Azure RBAC: the Azure door of the four doors, the people rule of the three rules | Real separate Reader/operator identities on an EC2 Arc machine |
| 33 | H20A | Turn a Defender finding into an owned action | Current coverage and one preselected finding on an EC2 Arc machine |
| 35 | H20C | Follow a training event into a Sentinel incident | Explicit harmless training marker from `cas26-arcwin01` |
| 42 | H24 | Govern an on-premises guest and an AWS server with one Policy cycle: the Require-an-Owner-tag policy from slides 39-40 | Exact targets/assignments for both passes; both DoNotEnforce |
| 47 | H23F | Update Manager across every estate: assess, schedule, patch, prove | One view of pending updates; ring0 tag-based dynamic scope; one-time security update on one on-premises and one AWS canary; history, fresh assessment and a fresh IIC order |
| 49 | H26 | Keep the EKS cluster the way Git says with Arc/Flux (AWS still owns the cluster) | Dedicated CAS26 ConfigMap on the Connected EKS cluster |

Detailed printable procedures are in [runbooks](runbooks/), and [preparation.md](preparation.md) lists the pre-delivery checks for each demo. SCVMM and vCenter are covered on slides 9-11 without a live demo; SCVMM platform onboarding was done ahead of the session. VMware remains an architectural comparison. The Cost section (slides 50-54) has no live demo; the [query desk](src/queries/README.md) includes ingestion evidence without inventing invoice savings.

## Presenter controls

Left/right arrows navigate steps. Keys 1–9 jump to the nine demos in run order. C copies the current command; T starts/pauses the timer. All nine remain available on small screens. Prerequisites open on the first step; speaker and attendee explanations expand separately. Reset and fallback stay available throughout.

Repository commands run from the repository root; guest commands run on the identified guest; KQL uses the specified query engine. The configured JSON does not change shared bootstrap targets in `shared/foundation/config/variables.yml`: reconcile both before onboarding. Timer values are advisory targets. If a step exceeds its live window, show the rehearsal capture and name the step you would have run.

## Maintenance

- `demo-content.json`: canonical authored steps, explanations, sources and reset/fallback.
- `demo-console.html` and `runbooks/*.md`: generated delivery formats.
- `preparation.md`: shared staging and rehearsal gates.
- `config/demo.example.json`: schema; local populated copy is gitignored and contains no credentials.
- `scripts/Enter-DemoContext.ps1`: identifier/type/scope and CLI-context validation without changing login.
- `scripts/Test-DemoReadiness.ps1`: read-only inventory checks plus manual gates; successful exit is not full readiness.
- `src/queries/`: scoped Resource Graph/KQL examples; `src/eks-gitops/`: manifest and reset guidance.
- `evidence/README.md`: actual-observation format; `review.md`: review and validation results.

The build and export scripts are not part of this repository.

The demo assets reuse shared implementations. Updating them does not rebuild the deck.
