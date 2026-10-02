# Hybrid Operations 2026

## Submitted conference description — authoritative contract

> Hybrid cloud was meant to be a short-term solution, but in reality, most IT environments are hybrid for the long haul—and that’s just how it is. By 2026, IT Pros are managing environments that span Azure, on-premises infrastructure, edge locations, and at least one system that should have been retired years ago.
>
> This session provides a practical—and occasionally humorous—look at how to operate hybrid environments effectively, integrating monitoring, security, governance, cost, and automation under a single lens. Azure Arc serves as the control plane that ties it all together, enabling consistent management across disparate systems.
>
> Attendees will learn how to:
>
> - Monitor and observe everything: Using Azure Monitor, Log Analytics, and Health Models to gain actionable insights across on-prem, Azure, and multi-cloud workloads
>
> - Secure the hybrid stack: Applying Defender for Cloud, Microsoft Sentinel, and Zero Trust principles to protect resources wherever they reside
>
> - Govern and manage efficiently: Leveraging Azure Policy, landing zones, and Entra ID to enforce compliance and identity management at scale
>
> - Optimize costs and operational impact: Understanding telemetry, data ingestion trade-offs, and cloud/on-prem consumption to reduce surprises on the bill
>
> - Adopt patterns, not just tools: Applying lessons learned from decades of SCOM, Ops, and hybrid deployments to avoid alert fatigue, duplicated effort, and blind spots
>
> We’ll also sprinkle in a bit of humor—because if you can’t laugh at that one Arc-enabled server nobody dares to reboot, hybrid operations might start to feel like punishment instead of work.
>
> By the end of this session, IT Pros and cloud operators will leave with a practical, forward-looking playbook for managing hybrid environments: what to adopt, what to unlearn, and how to survive—and maybe even enjoy—the hybrid world of 2026.

The organizing question is: **How do we operate one hybrid estate consistently when its infrastructure, tools and teams span different places?** Azure Monitor is an operational overview here; the separate **observability session** (`azure-monitor-hybrid-multicloud-observability`) owns **implementation depth** for:
- Hybrid monitoring architecture.
- Service-centric monitoring with Health Models.
- Turning telemetry into actionable health signals.
- Avoiding alert fatigue and legacy monitoring mistakes.
- Cost and data ingestion trade-offs.

This session focuses on **operational integration** (e.g., 'How does monitoring fit into hybrid governance?'), while the observability session dives into **technical implementation** (e.g., 'How to set up Log Analytics?').

## Current artifacts

- `presentation/decks/` — `hybrid-operations-2026-dark.pptx` (speaker) and `hybrid-operations-2026-attendee-dark.pptx` (attendee), 64 slides each. See [presentation/README.md](presentation/README.md).
- `presentation/outline/README.md` and `presentation/pacing-guide.md` — teaching outline and adjustable presenter checkpoints; timing is not an acceptance gate.
- `presentation/outline/storyboard.md` — slide-by-slide storyline, evidence, transition, and source checks.
- `demos/README.md` and `demos/demo-console.html` — bounded demonstrations, prerequisites, expected evidence, reset, and fallback.
- `handouts/README.md` — two handouts in editable Markdown and matching PDFs: the session companion (with query patterns, service operating contract and glossary) and the desk playbook.
- `presentation/decks/hybrid-operations-2026-attendee-dark.pptx` — the same 64 slides with attendee explanations; the speaker decks carry KEY POINTS, TALKING POINTS and PURPOSE. Both note sets also have Markdown exports.

The deck, demos, runbooks and handouts present the CAS26 lab environment as it was deployed and configured for delivery. The nine demos contain 58 detailed steps. The lab was torn down on 2 October 2026; commands and queries need your own environment.

## Evidence status

The lab was torn down on 2 October 2026. The environment this session demonstrates — the AWS multicloud connector, all Arc-connected servers and the EKS cluster, the monitoring workspaces, Health Model and data collection rules, Sentinel, the on-premises SCVMM-managed cluster and its Arc resource bridge, the IIC Hybrid Orders application, the Sentinel training event, Flux on the EKS cluster, Azure Update Manager on every estate, and the Policy assignments used in the H24 demo — was presented as deployed and configured throughout the deck, demos and runbooks. The lab's build record is in lab/status/, not in session-facing material.
