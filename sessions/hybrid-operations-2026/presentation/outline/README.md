# Hybrid Operations teaching outline

The [storyboard](storyboard.md) records the delivered 64-slide sequence. The speaker and attendee decks follow it and carry separate notes for their audiences.

After individual guest onboarding, the sequence explains guest versus virtualization-platform management, introduces resource bridge and SCVMM architecture, introduces the already-prepared SCVMM-hosted workloads, and compares Arc-enabled VMware vSphere. SCVMM Arc enablement was completed beforehand in the shared environment, not demonstrated live. The presenter demonstrated those workloads as part of the Arc inventory, monitoring, access, security, and governance examples where configured. The management section returns to their workload outcomes before AWS management. VMware receives substantive architectural coverage without assuming a live VMware demo environment.

| Slides | Section |
|---|---|
| 1–5 | Opening: sponsors, presenter, hybrid reality, agenda |
| 6–17 | Azure Arc: one server, SCVMM and vCenter, the multicloud connector and AWS onboarding, edge and legacy, the four onboarding paths |
| 18–20 | From managing to operating: the IIC Hybrid Orders service |
| 21–27 | 1 · Observe |
| 28–35 | 2 · Secure: access, Defender for Cloud, Microsoft Sentinel |
| 36–49 | 3 · Govern: landing zones, Azure Policy, compliance, Update Manager and ESUs, GitOps with Flux on EKS |
| 50–54 | 4 · Cost |
| 55–59 | 5 · Adopt the patterns: automation, what to adopt, what to unlearn, the first thirty days |
| 60–62 | Resources, the complementary Observability session, recommendations |
| 63 | Questions |
| 64 | Thank you — feedback and resources |

[Presenter pacing guide](../pacing-guide.md).

The storyline follows the submitted contract and presenter revisions: title → sponsor → brief bio → permanent hybrid reality → five outcomes → Arc foundation → one-server definition and architecture → **hands-on Arc server onboarding** → guest/platform distinction → SCVMM architecture and prepared workloads → VMware comparison → estate-scale resource paths → multicloud connector and EC2/EKS object explanation → **hands-on AWS connector discovery/onboarding** → connected-edge and legacy boundary → management/telemetry/application separation → operating-service transition → one-slide monitoring overview (collect, store, use) with the Observability plug, the DCR mechanic, SCOM/service-model context and the query/health demo with alert ownership → identity/access and RBAC demo → Defender explanation/demo → Sentinel explanation/demo → landing-zone overview → Arc landing zone accelerator → Policy explanation with enforcement mode → one Policy demo that opens by recalling the onboarded EC2 server, then runs on the on-premises guest and on that EC2 server → SCVMM-hosted workload management → update management across the three estates (why one process, how Azure Update Manager does it, ESUs for end-of-support servers, one-schedule demo) → EKS management → cost worked example and total cost → combined automation decision flow → adopt/unlearn/first-30-days playbook → resources → Questions.

The Arc server demo and AWS connector demo are separate. The first proves how owned on-premises/edge machines become `Microsoft.HybridCompute/machines` resources. The second proves how the source-cloud authorization, Inventory, server-onboarding, and EKS-onboarding solutions represent or onboard AWS resources. The merged Policy demo (slide 42), the Update Manager demo (slide 47) and the EKS Flux demo (slide 49) show management actions after onboarding. Edge is presented as remote but connected: Arc management requires connectivity to Azure endpoints and is not described as fully disconnected support.
