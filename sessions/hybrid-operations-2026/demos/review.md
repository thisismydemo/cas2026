# Demo review — 2026-09-23

Scope: the Hybrid Operations demo folder and its generated console. No slide-deck rebuild, infrastructure deployment or live cloud demonstration was performed for this update.

## Delivered coverage

Nine demos match the storyboard's stable IDs and, in deck order, slides 8, 15, 27, 31, 33, 35, 42, 47 and 49 of the 64-slide storyboard (on 2026-09-26 the two Policy demos were merged into one two-pass demo, the monitoring overview was trimmed and the Update Manager demo H23F was added; on 2026-09-30 the deck was renumbered, H23F became a four-step tour and the SCVMM workload demo was removed; see `preparation.md` for targets). There are 58 detailed steps, each with expected evidence, failure guidance, speaker explanation and attendee takeaway. Printable runbooks and console are generated from the same JSON. Supporting preparation, configuration, read-only checks, queries, EKS guidance and evidence capture instructions are included.

SCVMM and vCenter are taught on slides 9-11 without a live demo; SCVMM platform enablement is done ahead of the session. VMware remains architectural coverage. Both sessions and the AWS landing scope are included in preparation.

## Independent models and dispositions

Used HCS MCP `foundry_compare_models` with the existing second-opinion and adversary deployments: **deepseek-v4-pro** for technical review and **grok-4-20-reasoning** for an independent challenge. These existing accessible roles were adequate for text/command review; no model deployment was created. The local agent verified their suggestions against source and documentation; model agreement is not proof of live readiness.

The first extraction failed because the Windows console could not encode a Unicode arrow. That attempt provided no usable content review. It was rerun with a valid UTF-8/escaped export. The actual full-content review is retained in [evidence/foundry-review.txt](evidence/foundry-review.txt). Reported full-review usage: DeepSeek 9,404 input / 1,411 output tokens; Grok 8,936 input / 675 output. Failed-export attempt: 797 input / 1,269 output combined. No monetary cost was reported, so no cost estimate is asserted.

| Finding | Resolution |
|---|---|
| Sentinel CLI query could target the monitoring workspace instead of Sentinel | Resolve properties.customerId from the actual Sentinel workspace ARM ID before Event and SecurityIncident queries. |
| Raw per-Computer service counts could misrepresent customer requests | Bind to the endpoint Computer and deduplicate RequestId; display sample count and latest evidence. |
| Native command failures could permit later steps to continue | Add explicit exit checks to changing commands, expected-denial handling and try/finally worker recovery. Read-only results still require the per-step evidence check. |
| Missing Owner versus incorrect Owner, and placeholder ownership | Explain the actual shared modify/add condition and inspect assignment plus definition defaults. A compliant placeholder is not accountable ownership. |
| Flux prune can remove the namespace | Keep the default between-session reset nondestructive; require full namespace ownership inspection before optional post-rehearsal deletion. |
| Model suggested no Sentinel mismatch because ARM ID/GUID are distinct | Rejected that reasoning: different ID formats do not establish that the two configured IDs identify the same workspace. Explicit derivation is required and implemented. |
| Model repeated already-correct resource-scoped remediation and reset warnings | Retained verified implementation; did not make unnecessary changes. |

Primary checks included [Azure Policy remediation CLI](https://learn.microsoft.com/en-us/cli/azure/policy/remediation?view=azure-cli-latest), [Flux lifecycle/pruning](https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/tutorial-use-gitops-flux2), and [Usage table units](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/usage). The shared governance, request service, Windows event helper and worker-state helper were inspected directly. Other per-demo primary references are preserved in the runbooks.

## Local verification

- `python tools/validate_hybrid_demos.py`: correct sequence and slide IDs, mandatory detailed fields, generated-runbook parity, console step count, offline dependencies and local links.
- PowerShell parser: helper scripts and all authored PowerShell command blocks parse without syntax errors.
- `pwsh -NoProfile -File tools/test_hybrid_demo_context.ps1`: accepts valid offline config; rejects wrong RG/type, embedded URL credentials, invalid GUID, placeholder and a mocked wrong signed-in subscription. Offline readiness explicitly says cloud checks were not run.
- `python tools/test_hybrid_demo_console.py`: Chromium renders every step and exact command text; checks previous/next/jump navigation, reload persistence, timer, desktop/mobile navigation, reset/fallback panels, no JavaScript errors and no HTTP requests.
- Rendered desktop/mobile screenshots were inspected. Fixed a flex-layout defect that collapsed command panels and added a browser assertion for visible command-panel height. Screenshots are local under `tmp/demo-console-review/`.

## 2026-09-27 update: delivery wording and Foundry audit fixes

The demos now describe the environment as deployed and configured: the per-demo lab-status lines were removed, and each `fallback` is a neutral live-demo contingency (show the rehearsal capture and name the step). Confirmed demo findings from `pmo/audits/hybrid-operations-2026-foundry-audit.md` section 3 were applied: `health-failure.kql` keys on the telemetry contract (H1); the H16 order and Health Model guards and the `provisioning` field (H2, H8, H15); one EC2 count, eight CAS26 EC2 Arc machines of which the six IIC application servers are the H24 allowlist (H5); EKS Connected (H6); the H19 target-separation reason (H7); `cas26-lnx01` naming (H9); the SCVMM-demo transition (H10; that demo was later removed); slide references and counts (H12, H13); the existing AWS Owner-tag assignment (H14); the Sentinel `arg_max` order (H16); a Defender assessment query for freshness (H18); and the H23F debrief line (H19).

## 2026-09-30 update: aligned with the final 64-slide deck

- Slide numbers, titles, minutes and transitions of all ten demos now follow `presentation/outline/storyboard.md` and the speaker notes; `tools/validate_hybrid_demos.py` reads slide numbers, titles, minutes and deck order from the storyboard itself (the deck-build output `session-content.json` can lag it).
- H23F is a four-step tour matching slide 47: one view (Azure, on-premises and AWS pending updates in one list and one query), how machines get picked (ring0 maintenance configuration and its tag-based dynamic scope), run it (one on-premises and one AWS canary in the same window), prove it (update history, a fresh assessment and a fresh IIC order with the shared order client). The live re-tag step was removed, so H23F no longer changes tags.
- H19 is framed with the four doors and the three key rules; H26 with the plain-words Flux framing (AWS still owns the EKS cluster; Arc and Flux govern what runs on it). Section transitions use the five section names: Observe, Secure, Govern, Cost, Adopt.

## Before each delivery

Populate local identifiers; verify landing-zone, AWS placement, SCVMM bridge/guest mapping, AMA/DCR routes, Defender coverage, Sentinel rule/incident path, effective roles, exact policy defaults/permissions and EKS/Flux configuration. Rehearse and time the demos, capture before/after evidence as the on-stage contingency and verify shared-state reset. Local asset validation does not replace that rehearsal.

## 2026-09-30 final update: nine demos, clarity pass

- The SCVMM workload demo was removed from the deck and from these materials: its content, generated runbook, README/preparation rows, the `ScvmmArcResourceId` configuration key (example config, `Enter-DemoContext.ps1`, `Test-DemoReadiness.ps1`, context test) and the SCVMM-bridge readiness gate. `Set-Cas26WorkerMode.ps1` stays: it is the H16 reset path and is shared with the Whole-Service Observability session.
- Slide numbers follow the final storyboard: H24 is slide 42 (after Azure Policy, How Azure Policy works and Compliance) and is followed by "What the Policy demo proved" (slide 43). Transitions match the new neighbours: H07B → SCVMM and vCenter (slide 9); H11 → edge and legacy (slide 16); H16 → Secure; H19 → Defender for Cloud; H20A → Microsoft Sentinel; H20C → Govern; H24 → what the Policy demo proved; H23F → Flux; H26 → Cost.
- Clarity pass on every step: the body says what to click or run, "expected" says what appears, "if this fails" is specific, the speaker line is what to say (no longer a copy of the body) and the attendee line is a takeaway. Each runbook opens with a plain-language "What this demo shows and why" paragraph, a "Names used in this runbook" line and a generic "To reproduce" line; presenter-only items are marked "Presenter lab". H24 now ties explicitly to the Require-an-Owner-tag policy and walks the boxes of slide 40. DCR wording follows slide 23 (data collection rule, DCR association). H19 restores the reserved tag with a command instead of a portal-only step.
- `README.md` has a run-order table and `preparation.md` a morning-of-delivery pre-flight checklist. `tools/validate_hybrid_demos.py` expects nine demos and additionally checks that no reference to the removed demo remains, that the runbook set matches, that each runbook has its purpose and names lines, that speaker/attendee lines are not copies, and that each demo's closing transition names its next deck section.
