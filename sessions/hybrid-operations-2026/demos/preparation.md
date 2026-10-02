# Shared preparation and rehearsal

Owner: presenter / shared lab operator. Complete before either session; resource existence alone does not pass a demo. The [run order](README.md#run-order-for-delivery) lists the nine demos with their slides and minutes; the [pre-flight checklist](#pre-flight-checklist-morning-of-delivery) below is the last pass on the day.

## Pre-flight checklist (morning of delivery)

Run top to bottom from the presenter jump (`tplabs-jmp-c26`), PowerShell 7, repository root. Anything that does not pass: switch that demo to its rehearsal capture now, not on stage.

1. [ ] `az account show` is the presenter identity; `az account set --subscription <workload>` done (the jump defaults to the management subscription).
2. [ ] `Test-DemoReadiness.ps1` (online) has no FAIL or MISSING rows; the report is saved under `evidence/local/`.
3. [ ] `. ./sessions/hybrid-operations-2026/demos/scripts/Enter-DemoContext.ps1 -ConfigPath ./sessions/hybrid-operations-2026/demos/config/demo.local.json` reports no PENDING targets.
4. [ ] H07B: `cas26-arcwin01` is up and reachable; `Connect-Cas26Arc.ps1 -Target Windows -DryRun` names only that guest; the machine has no `Owner` tag.
5. [ ] H11: connector page and the AWS CloudFormation stack open in the browser; eight EC2 Arc machines and `eks-iic-cas26-use2-01` Connected.
6. [ ] H16: one order placed with `Invoke-Cas26Request.ps1` completes; its rows are in `Cas26Service_CL`; both IIC workers are in `Healthy` mode; Resource Graph, Logs, workbook and health model tabs open with the right scope and time range.
7. [ ] H19: reader and operator terminals signed in (separate `AZURE_CONFIG_DIR`); `CAS26RbacProof` absent on the RBAC machine, or its value recorded.
8. [ ] H20A: the preselected recommendation still applies; owner, window and assessment time recorded.
9. [ ] H20C: training event written on `cas26-arcwin01`; a fresh `CAS26 TRAINING` incident exists; older training incidents closed.
10. [ ] H24: `cas26-arcwin01` and `iic-cas26-prd-api-01` both NonCompliant for the missing `Owner` tag; both assignments `DoNotEnforce`; original tags recorded.
11. [ ] H23F: both canaries `UpdateRing=ring0-canary` and in the ring0 dynamic scope; `$AwsCanary` set in the presenter terminal; no update run in progress.
12. [ ] H26: `microsoft.flux` extension healthy; `git ls-remote` returns the recorded commit; `cas26-demo` absent or verified as this exercise's.
13. [ ] Rehearsal captures for all nine demos are open in one folder, in run order.
14. [ ] The [demo console](demo-console.html) opens on H07B step 1.

## Demo targets and pre-delivery checks

The application is IIC Hybrid Orders (`lab/design/HYBRID-APPLICATION-HEALTH-DESIGN.md`). Resource names below are the deployed CAS26 names; durable IDs come from the CAS26 Key Vault into the gitignored `demo.local.json`.

| Demo | Target | Pre-delivery checks |
|---|---|---|
| H07B Arc onboarding (8) | `cas26-arcwin01` on the standalone Hyper-V host `MGMT-RAL-HV-01` | Guest booted and reachable from the jump; local admin credential from the CAS26 vault; `variables.yml` pointed at this guest/host; onboards into `rg-tplabs-cas26-ops-eus-01` with `Event=cas26` and no `Owner` tag. |
| H11 AWS connector (15) | Connector `pcc-tplabs-cas26-aws-eus-01`; eight EC2 Arc machines (six IIC application servers, two SQL Server machines) and EKS `eks-iic-cas26-use2-01`, all Connected | Record `Ec2ArcResourceId`/`EksArcResourceId`; rehearse the inspect-only flow. |
| H16 estate query + health (27) | EC2 Arc machine for machine evidence; IIC Hybrid Orders (`ServiceUrl`); Health Model `hm-tplabs-cas26-service-cus-01` | Record `ServiceUrl` and `HealthModelResourceId`; place one rehearsal order and confirm its rows in `Cas26Service_CL`. |
| H19 RBAC (31) | A second EC2 Arc machine (`Ec2RbacArcResourceId`, for example `iic-cas26-prd-web-01`), never the H24 target | Keep H19 off the H24 target so rehearsal tag writes do not disturb its Policy before-state. Choose reader/operator from `cas26-test-*`; verify scoped assignments at the `AWS_<AccountId>` RG or exact machine; reserve `CAS26RbacProof`. |
| H20A Defender (33) | EC2 Arc machine (about 40 Linux hardening findings each) | Preselect one finding; record assessment time and owner. |
| H20C Sentinel (35) | `cas26-arcwin01` → `law-tplabs-cas26-security-eus-01` | AMA and the Windows Application-log route into the security workspace; training rule enabled; fire the training event before the slot. |
| H24 Policy, on-prem then AWS (42) | Pass 1: `cas26-arcwin01` under `tplabs-cas26-require-owner-tag-modify`; pass 2: `iic-cas26-prd-api-01` under the `cas26-modify-owner-tag-aws-arc` assignment | Both assignments `DoNotEnforce`; both targets evaluate NonCompliant for the absent `Owner` tag. Rehearse on a dev EC2 machine; reset = delete the Owner tag. |
| H23F Update Manager (47) | Canary machines `cas26-arcwin01` and one AWS dev machine (for example `iic-cas26-dev-web-01`), both `UpdateRing=ring0-canary`; IIC Hybrid Orders (`ServiceUrl`) for the closing order | Four-step tour: one view, ring0 dynamic scope, one-time run, proof. Five ring maintenance configurations with dynamic scopes on the ops and AWS RGs, UpdateRing/Environment/Workload tags on every CAS26 Arc machine (confirm both canaries are still `ring0-canary`), periodic-assessment policies, fresh assessments; check which Azure VMs, if any, appear in the one view; rehearse the one-time security update and the fresh order. Never patch the IIC workers live. |
| H26 EKS Flux (49) | EKS connected cluster `eks-iic-cas26-use2-01` | `microsoft.flux` extension and the `cas26-demo` configuration per `src/eks-gitops/README.md`; verify reconciliation and rehearse. |

Running from the presenter jump (`tplabs-jmp-c26`): the Azure CLI there is signed in as the presenter identity, so `Test-DemoReadiness.ps1` and the H24 governance script (`-UseAzCliToken`) run without pasting tokens. Select the workload subscription first (`az account set --subscription <workload>`) because the CLI default is the management subscription. The connector-created AWS resource group is named in lower case (`aws_<accountId>`); the docs' `AWS_<AccountId>` is the same group.

## Environment map and landing zone

Populate `config/demo.local.json` from verified inventory. Record tenant/subscription, operations RG and connector-created `AWS_<AccountId>` RG. The shared landing-zone design must intentionally cover both scopes; an operations-RG policy does not automatically cover AWS resources.

Keep this map in gitignored `evidence/local/estate.md`:

| Source | Native identity | Azure identity | Workload identity |
|---|---|---|---|
| On-prem / edge guest | Host and VM name | HybridCompute machine ID | Computer, OS, agent version |
| SCVMM workload | VMM server, VM GUID | One HybridCompute machine ID (kind SCVMM) carrying lifecycle and guest management | Guest hostname, worker role, SSH/console route |
| EC2 | Account, region, instance ID | Discovery representation AND HybridCompute machine ID | Guest hostname and OS |
| EKS | Account, region, cluster ARN | Microsoft.Kubernetes/connectedClusters ID | Exact kubectl context and API endpoint |

Validate mappings in both source and Azure views; names alone are insufficient. Record the lab operator/contact and reset responsibility. Keep credentials in approved stores, not configuration or captures. `LogAnalyticsWorkspaceId` is the customer GUID for query CLI; `SentinelWorkspaceResourceId` is the full ARM ID.

Before delivery verify:

- Resource organization, regions, identity groups, network/DNS/proxy routes, accountable owner, cost tags and retention choices.
- Providers and installed versions of Azure CLI, connectedmachine, resource-graph, connectedk8s, k8s-configuration, log-analytics and kubectl. Install tools in preparation, not on stage.
- Effective Policy inheritance, exclusions/exemptions, assignment effect/enforcement and remediation identity permissions across both RGs.
- Defender plans/integrations and healthy agents for each demonstrated resource type; record actual coverage and cost responsibility.
- Sentinel-enabled workspace, access, connector/event DCR, analytics rule, incident creation and retention. Defender coverage does not establish Sentinel readiness.
- Outbound paths for server agents, bridges, Kubernetes agents, AMA, Git and service requests. Edge means connected edge; no disconnected Arc-management claim.

See `shared/foundation/environment.md` and `plan.md` for the common design.

## On-premises worker and SCVMM

There is no live SCVMM demo; SCVMM and vCenter are taught on slides 9-11. Arc-enabled SCVMM was set up ahead of the session and is not onboarded live.

`cas26-lnx01` (on the SCVMM cluster) runs the IIC on-premises validation worker, so every order in H16 and H23F passes through it. Before either session confirm the worker is in `Healthy` mode (`Set-Cas26WorkerMode.ps1 -SshTarget <user@host> -DryRun` reads the current state), that AMA and its DCR association are in place, and that a fresh order completes. Never patch it live. Reconcile `shared/foundation/config/variables.yml` with the demo JSON: the existing bootstrap reads the former. Recording an ID in demo JSON does not change bootstrap targets.

The Windows event guest is `cas26-arcwin01`; `Write-Cas26Event.ps1` requires Windows, so do not paste it into the Linux worker terminal. VMware gets an architectural comparison unless a separately verified environment is prepared.

## AWS: stage later management independently of discovery latency

Verify account/region, available connector solution types, current prerequisites and CloudFormation permissions. Rehearse discovery/onboarding, capturing native and Azure identities. Detect existing Arc connections before running onboarding. Do not duplicate existing server or cluster connections for the presentation.

Record the EC2/EKS targets for the later management demos. Verify landing scope controls and telemetry/security coverage. An Azure tag on the Arc EC2 representation is not a native AWS tag.

## Monitoring: prove the request and its evidence

1. The service is IIC Hybrid Orders (`lab/design/HYBRID-APPLICATION-HEALTH-DESIGN.md`): Front Door → Azure Container Apps / EKS portal origins → Functions coordinator → Service Bus → on-premises validation worker (`cas26-lnx01`) and AWS fulfillment worker.
2. Verify the portal/coordinator URL (`ServiceUrl`). Place one order; capture CorrelationId, serving origin, UTC time and result.
3. Confirm the route produces `Cas26Service_CL` (Direct DCR `dcr-cas26-requests-eus-01`), plus heartbeat, guest performance and Windows event data. The IIC Linux EC2 Arc machines report Heartbeat/Perf through `dcr-tplabs-cas26-linux-eus-01`. Inspect AMA, DCR associations and destinations. A DCR alone does not bind collection to a machine.
4. Run the query desk in the intended workspace against exact identifiers. Check age and sample count. No rows remain insufficient evidence; don't remove scope filters merely to obtain results.
5. Open the rehearsed workbook/service view. If using Health Models, inspect its actual freshness/rollup behavior; do not imply every stale child makes the parent Unknown. Keep the walkthrough at customer outcome, owner, action and recovery level.

## Identity, Defender and Sentinel

Use separate browser profiles for real Reader and operator identities. Record object IDs, scopes, inherited roles, PIM state and session expiry. Rehearse allowed reads and a harmless Reader write that fails due to authorization. A hidden button is not an observed denial. If the write unexpectedly succeeds, record the permission issue and restore the original value. Arc extension/Run Command rights can confer privileged guest execution even though management and guest sign-in are different boundaries.

For Defender choose a current recommendation/finding on the mapped machine. Record its time, plan, evidence and owner/action. Don't weaken a machine to manufacture a finding.

For Sentinel, register the `CAS26Demo` event source on the Windows guest once with `Write-Cas26Event.ps1 -RegisterSource`. Prepare collection and the rule based on `sessions/hybrid-operations-2026/demos/src/queries/sentinel-training-event.kql`, with `CAS26 TRAINING` incident prefix. Rehearse event→ingestion→rule→incident, scheduled-rule latency and grouping. Event Viewer output is not evidence of incident creation.

## Policy: one demonstration, two hosting locations

H24 (slide 42) runs the Require-an-Owner-tag policy from slides 39-40 through the full cycle first on the on-premises guest onboarded in H07B, then on the connector-onboarded EC2 Arc representation, with the same runbook and only the target/assignment variables changed. Use exact target and assignment IDs. The assignment `tplabs-cas26-require-owner-tag-modify` is scoped to `rg-tplabs-cas26-ops-eus-01` and matches only `Event=cas26`; connector-created Arc machines do not carry that tag, so the AWS pass uses the separate assignment of definition `cas26-modify-owner-tag-aws-arc` at the `AWS_<AccountId>` RG. It allowlists the six IIC application machines by exact name (every other machine in that group is outside its scope), and its managed identity holds Tag Contributor at that scope. Record its full assignment ID as `Ec2PolicyAssignmentId`.

The shared governance module performs **modify/add only when Owner is absent**. It does not repair wrong or empty values. Inspect the assignment AND definition: its default may be an unassigned-style placeholder. Match `ExpectedOwner` to the effective intended value and explain whether that identifies a real accountable owner.

Both Owner-tag assignments (`tplabs-cas26-require-owner-tag-modify` on the ops RG and `cas26-modify-owner-tag-aws-arc` on the AWS RG) run with `enforcementMode=DoNotEnforce`. Reason: in `Default` mode the Arc agents' routine status writes trigger the Modify effect and tag every matching machine within seconds, so nothing is ever NonCompliant on stage. In `DoNotEnforce` mode compliance is still evaluated and manual remediation tasks still run ([assignment structure](https://learn.microsoft.com/azure/governance/policy/concepts/assignment-structure#enforcement-mode)), which is exactly the demo: NonCompliant → resource-scoped remediation task → fresh evidence. Do not switch either assignment back to `Default` before the sessions. Reset between rehearsals: delete the `Owner` tag on the Arc representation (`az tag update --resource-id <arc id> --operation Delete --tags Owner=<value>`); it stays deleted because the effect is not enforced on writes. Save original tags first. If a target is already compliant, show its remediation history and say no repair was needed. Confirm the assignment identity has required permissions, then use resource-scoped remediation and fresh evaluation times. Task submission is not proof of compliance or customer recovery.

## EKS: desired state and bounded reset

Follow [the EKS companion](src/eks-gitops/README.md). Verify source ARN→Arc ID→kubectl context, Git access, configured branch/path, extension readiness and permissions. Rehearse applying the scoped configuration or correcting a harmless ConfigMap drift. Show actual revision and object content.

The manifest includes the namespace, so `prune=true` can delete that namespace during configuration removal. Prefer leaving the desired state intact between sessions. Before any cleanup enumerate all namespaced resource kinds and ownership, not just `kubectl get all`. If any foreign workload is present, stop cleanup. Never remove shared Flux extensions or Arc connections as a reset.

## Rehearsal and handoff

Run `Test-DemoReadiness.ps1`, then complete every MANUAL gate with evidence. Rehearse all nine demos in deck order (H07B, H11, H16, H19, H20A, H20C, H24, H23F, H26), measuring clicks, waits, explanation and reset.

Capture actual before/after results using [the evidence template](evidence/README.md); these rehearsal captures are the contingency if a portal or query is slow on stage. Before the second session check healthy worker mode, fresh requests, intended identities, policy state, Sentinel training noise and Flux revision. On failure show the rehearsal capture and contact the recorded lab operator; do not widen scope or permissions while presenting.
