# Hybrid Operations review evidence

Review date: 2026-09-23. Scope: revised 54-slide storyboard, diagram source, and both note audiences. Text-model reviews do not establish rendered appearance or live deployment.

## Independent technical review

HCS Foundry compared `second-opinion` (deepseek-v4-pro) and `adversary` (grok-4-20-reasoning). Source review covered the new diagram code; two further batches covered both note sets for all 54 stable IDs. These roles were used for independent criticism across models; the local orchestrator retained acceptance decisions.

Accepted source findings: separate DCR/DCRA configuration from telemetry delivery; show connector-created AWS resource-group scope; make guest/platform separation explicit; clarify Sentinel collection prerequisites. These were applied before final delivery.

Rejected source findings: the service dependency arrow was already endpoint-to-worker; Health Models depth correctly follows the presenter’s overview-only boundary. A suggestion to imply model implementation in this session was rejected.

Notes review disposition: both models found no material issues in the security/governance/cost/closing batch. One model approved the earlier batch while the other supplied several unsupported corrections. Retain Arc system-assigned managed identity (not a generic device identity); retain the resource bridge as a continuing management dependency; retain PromQL for the supported workspace metrics; retain the qualified statement that configured rollup can exclude unknown children. The proposed AMA destination correction was already present in the quoted text. Expand resource-type shorthand where it improves precision, without changing the architecture.

Primary checks used to resolve disagreements:

- https://learn.microsoft.com/en-us/azure/azure-arc/servers/security-identity-authorization
- https://learn.microsoft.com/en-us/azure/azure-arc/servers/security-extensions
- https://learn.microsoft.com/en-us/azure/azure-monitor/vm/metrics-opentelemetry-guest
- https://learn.microsoft.com/en-gb/azure/azure-monitor/metrics/data-platform-metrics
- https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/rollup
- https://learn.microsoft.com/en-us/azure/azure-arc/multicloud-connector/onboard-elastic-kubernetes-service-clusters-arc
- https://learn.microsoft.com/en-us/azure/azure-arc/multicloud-connector/onboard-multicloud-vms-arc
- https://learn.microsoft.com/en-us/azure/azure-arc/system-center-virtual-machine-manager/overview

The general connector resource-representation page currently conflates EKS and server resource types. The specific Kubernetes onboarding documentation governs the deck’s connectedClusters path.

## Visual review

Independent reviewers inspected all 54 draft renders, split into slides 1–27 and 28–54. Findings applied: visible governance color, edge-agent outbound path and local-operation arrow, connector label offsets, explicit OTel preview label and metric-query distinction, landing-zone RG hierarchy, connected Flux controller/repository/namespace diagram, concrete collection trade-off table, four-category cost model, and removal of production-process wording from the EKS demo footer. Final affected-slide reinspection and text bounds are recorded with the render artifacts.

## Remaining boundaries

Final delivery verification passed: 54 slides in each deck; all 54 stable IDs match storyboard order; every embedded note matches the separately authored audience-specific source; visible slide XML is identical across both decks; 9,892 presenter-note words and 6,822 attendee-note words. Technical slides contain editable PowerPoint shapes/connectors. The approved About Me slide remains an image to preserve its appearance.

PowerPoint text-bounds inspection returned no overflow. After the final render, reviewers requested five remaining connector-label fixes on slides 11, 13, 17, 19, and 42. Those were applied to both decks and the build source, the affected slides were re-exported, and the independent reviewers confirmed all reported visual defects resolved. Dual-deck validation passed again after the repairs. This establishes the delivered slide/note artifacts, not live-environment readiness.

The sponsor slide intentionally retains the event-artwork placeholder from the approved source. Expanded SCVMM/VMware timing has not been rehearsed or reconciled to a final 90-minute allocation. Shared-environment deployment and current demo evidence remain separate open requirements in plan.md. Render/static/model review does not prove that those cloud actions ran.

## Full notes-review tool output


### Batch 1

===== second-opinion =====
[second-opinion -> deepseek-v4-pro | 22.9s | in 12606 / out 1043 tokens]

I reviewed slides H01 through H16.

**Findings**

1.  **H06A [Attendee] – Unsupported Claim: Managed Identity**
    The attendee notes state: "A managed identity enables supported machine-to-Azure interactions..." This implies the Connected Machine agent provisions a standard Azure Managed Identity resource on the machine. In the current documentation, the agent creates a device identity in Azure AD. While this functions for cloud interactions, calling it a "managed identity" directly is misleading as it is a different identity type with distinct behavior. The note should use "device identity" or a more general "cloud identity" to avoid implying a system-assigned Azure Managed Identity exists.
    *   **Correction:** Replace "managed identity" with "cloud identity" or "device identity" in this context.

2.  **H07D [Speaker] – Inaccurate Dependency Claim**
    The speaker notes state: "Mention that the bridge is an operating dependency with its own connectivity and lifecycle responsibilities." The requirement states SCVMM onboarding is done beforehand and workloads are demoed throughout. Calling the Arc Resource Bridge an "operating dependency" in a context where its ongoing lifecycle management is not part of the demo creates an unaddressed operational gap. The focus should be on the bridge as a pre-deployed prerequisite for the platform connection, not an actively managed runtime dependency for the attendee to operate during the session.
    *   **Correction:** Rephrase to "Mention that the bridge is a prerequisite component that must be deployed and maintained for the platform connection..." to limit its scope to a setup requirement.

3.  **H07A [Both] – Inconsistent Resource Type Naming**
    Both speaker and attendee notes refer to Kubernetes becoming a "connectedClusters" resource. The documented Azure resource type for Arc-enabled Kubernetes is `Microsoft.Kubernetes/connectedClusters`. The informal shorthand "connectedClusters" is an acceptable audience-facing term, but the speaker notes use it without the Azure resource provider prefix, which might cause confusion when looking at APIs. The attendee notes correctly use it as the resource type name. This is an inconsistency with the speaker notes' intent to teach the "object model concrete."
    *   **Correction:** In the speaker notes for H07A, clarify the resource as `Microsoft.Kubernetes/connectedClusters` for consistency with formal resource references.

4.  **H13A [Speaker] – Scope Mismatch on Preview Claim**
    The speaker notes claim: "...AMA collect OpenTelemetry guest metrics or receive application OTLP metrics for an Azure Monitor workspace..." This is correct per the allowed preview documentation. However, it creates a mismatch with the attendee notes, which say: "Preview AMA capabilities can also send configured OpenTelemetry guest or received application metrics to an Azure Monitor workspace." The attendee notes omit the key detail that this is an OTLP ingestion path *to an Azure Monitor workspace*, a distinction critical since attendees might expect it to go to Log Analytics. The speaker notes are better, but the attendee notes lose the destination, creating a minor factual gap.
    *   **Correction:** In the attendee notes for H13A, append "...to an Azure Monitor workspace" after "application metrics" to specify the destination.

5.  **H13B [Speaker] – Overstated Workspace Capability**
    The speaker notes state: "Azure Monitor workspaces host Prometheus metrics and supported OpenTelemetry metrics ingestion paths in preview; use PromQL for these workspace metrics." The verified docs specify that while the workspace is the destination for these metrics, its primary hosted query experience is for Prometheus metrics using PromQL. OTel metrics ingested this way are also queryable, but the phrasing "use PromQL for these workspace metrics" may confuse speakers into thinking OTel metrics require PromQL, which is not precisely how they are surfaced alongside platform metrics. It's an over-simplification. The safer phrasing is to keep them separate.
    *   **Correction:** Clarify as "...use PromQL for Prometheus metrics. Ingested OTel metrics are also queryable through the workspace."

6.  **H15 [Speaker] – Mismatch: Unsupported Health Model Behavior**
    The speaker notes state: "Unknown is an intended evidence treatment, not a guarantee that every missing child automatically changes the parent state; aggregation settings can exclude missing values." The allowed documentation states that Health Models rollup uses the worst state from children *unless* configured otherwise (explicitly stating a missing child can be ignored). Saying *missing* values *can* be excluded misstates the documented default. The documented behavior is that a missing signal *does* affect the parent unless specifically configured to be excluded. This statement inverts the logic.
    *   **Correction:** Change the speaker note to: "By default, missing child evidence typically propagates as 'Unknown' and can impact the parent. The model can be configured to ignore specific missing children, but this is explicit, not the default."

===== adversary =====
[adversary -> grok-4-20-reasoning | 25.3s | in 11829 / out 277 tokens]

**Reviewed:** H01–H16 (all slides in the batch).

**Findings:** None.

No material factual errors, unsupported deployment claims, attendee/speaker audience mismatches, or source conflicts were identified against the stated user requirements or the supplied verified documentation.

The notes correctly:
- Treat SCVMM onboarding as pre-session preparation and consistently demo only the hosted workloads.
- Use the same shared landing zone for AWS resources, explicitly including connector-created `AWS_<AccountId>` resource groups.
- Limit Health Models content to high-level relationships between signals, components, and service outcomes (H13C, H15, H16); model construction is explicitly deferred to the observability session.
- State that Policy, Defender for Cloud, and Sentinel are preconfigured elements of the shared baseline without claiming their runtime readiness is observed in the demonstrations.
- Correctly distinguish Hybrid Compute (`Microsoft.HybridCompute/machines`) for servers/EC2 from `connectedClusters` for EKS, aligning with the specific EKS onboarding documentation.
- Accurately reflect Azure Monitor workspace support for Prometheus and supported OTel metrics preview (with correct source links).
- Keep attendeeNotes free of speaking cues, transitions, or stage directions; they contain only content, limitations, and operational explanations. SpeakerNotes contain all delivery/transition guidance.

The material is consistent with current verified documentation and the constraints provided. No corrections required.

### Batch 2

===== second-opinion =====
[second-opinion -> deepseek-v4-pro | 6.1s | in 11911 / out 278 tokens]

I reviewed the speaker and attendee notes for all submitted IDs: H17, H18, H19, H20, H20A, H20B, H20C, H21, H21A, H22, H23, H23B, H23A, H24, H25, H26, H27, H28, H29, H32, H34, H35, H36, H37, H38, H39, H40.

No material factual errors, unsupported deployment claims, mismatches between note audiences, or source conflicts were found.

**Observations (suggestions, not errors):**
- The notes consistently avoid speaking/transition/stage cues in the attendee versions.
- The notes correctly distinguish between the capabilities of the shared landing zone and the preconfigured but unobserved readiness of Policy, Defender, and Sentinel.
- SCVMM-onboarded workloads are referenced appropriately as pre-demo prepared resources, and the shared AWS landing zone resource groups (including connector-created `AWS_<AccountId>` groups) are acknowledged.
- Health Models are kept at a high level, and the deeper implementation is correctly deferred to the complementary observability session.
- The indirect guest-execution risk wording is repeated across multiple security slides, which aligns with the stated design and does not introduce new factual conflict.

===== adversary =====
[adversary -> grok-4-20-reasoning | 25.7s | in 11342 / out 292 tokens]

**Review Summary**

**IDs reviewed:** H17–H40 (all slides in the batch).

**Findings:** 0

No material factual errors, unsupported deployment claims, audience mismatches (attendeeNotes contain no speaking/transition/stage cues), or source conflicts were identified.

The notes correctly:
- Treat Health Models as high-level only (H38 limits it to an overview and correctly places detailed authoring in the complementary session).
- State that SCVMM onboarding is a prerequisite completed beforehand and that SCVMM-hosted workloads are demoed throughout (H23B, cross-referenced in H21/H23B/H34).
- Consistently describe the shared landing zone as supporting AWS resources, explicitly including connector-created resource groups (AWS_<AccountId> pattern) and warning against assuming a single arbitrary group (H21A, H23A, H24).
- Treat Policy, Defender, and Sentinel as preconfigured elements whose readiness is not observed or demonstrated in-session (H20–H20C, H21–H21A, H34–H36).
- Use the correct resource type (`connectedClusters`) for EKS per the verified documentation and avoid the incorrect “HybridCompute” claim found on the resource-representation page (H23A, H25, H26).
- Distinguish limitations clearly in both note sets without inventing issues or contradicting the listed sources.

All content aligns with the supplied constraints and verified docs. No corrections required.
