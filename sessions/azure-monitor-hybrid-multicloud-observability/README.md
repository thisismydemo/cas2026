# Azure Monitor: Hybrid and Multicloud Observability Deep Dive

This session provides a **technical deep dive** into **whole-service observability** for one service that runs across **Azure, AWS and an on-premises private cloud**, using **Azure Arc, Azure Monitor and Azure Monitor Health Models**. It is designed as a **standalone experience** for attendees who want to **implement observability** that connects **customer outcomes to actionable insights**.

## Contents

- [presentation/](presentation/README.md): the speaker and attendee decks, notes and storyboard.
- [handouts/](handouts/README.md): the session companion and the observability field manual.
- [demos/](demos/README.md): runbooks, console, scripts, queries and rehearsal fixtures.
- `presentation/decks/observability-multicloud-reference/`: "Observability across clouds", an 87-slide reference deck.

## Session Goals

By the end of this session, attendees learned how to:

1. **Define customer outcomes** and design a **hybrid observability architecture** that scales across Azure, AWS and on-premises using **Azure Arc**.
2. **Implement whole-service observability** with **Azure Monitor Health Models**, shifting from resource alerts to **meaningful service health and impact analysis**.
3. **Correlate raw telemetry into actionable health signals** using **logs, metrics, workbooks, and health states** across hybrid and multicloud environments.
4. **Investigate impact and verify recovery** by applying **lessons from SCOM and modern observability practices**, avoiding alert fatigue and legacy monitoring mistakes.
5. **Understand cost, data ingestion trade-offs, and operational impact** when monitoring environments Microsoft doesn’t host.

This session goes **beyond tooling** into **design and operations**, providing **real-world guidance, architectural patterns, and hard-earned lessons** for IT Pros and cloud operators. Expect **detailed diagrams and flowcharts** to illustrate architecture, dependencies, and decision paths.

## Session description

A monitoring design that stops at “tell me when a server goes down” cannot explain whether users can complete their work, what a component problem affects, or whether recovery actually restored the service. This session builds a whole-service view across Azure, AWS, and on-premises infrastructure: define the customer outcome, collect and correlate evidence, model components and dependencies, investigate impact, take a bounded action, and verify recovery.

The session connects SCOM’s familiar service/component health-model idea to Azure Monitor Health Models without claiming identical products or a shared engine. Azure Monitor, Log Analytics, workbooks, request evidence, metrics, Health Models, alerts, and response all serve the operator’s questions. Multiple datacenters are present in the workplace requirement; only the prepared CAS26 path is shown as the demo implementation.

## Original submitted description — preserved baseline

> Most enterprise environments don’t live entirely in Azure—and pretending they do is how monitoring strategies fail. This 90-minute deep dive explores how Azure Monitor becomes a true hybrid observability platform when combined with Azure Arc, extending visibility across on-premises infrastructure, edge locations, and even non-Azure clouds.
>
> We’ll start by grounding the session in reality: how hybrid environments actually look today and why traditional “Azure-only” monitoring assumptions break down. From there, we’ll walk through how Azure Arc enables Azure Monitor to collect logs, metrics, and insights from systems Microsoft doesn’t host.
>
> A major focus of this session is Azure Monitor Health Models (preview)—a concept that will feel familiar to anyone who lived through the System Center Operations Manager (SCOM) era. We’ll explore why Microsoft is reintroducing health modeling, how it differs from legacy SCOM approaches, and how it enables service-centric monitoring instead of alert sprawl.
>
> This session goes beyond tooling into design and operations:
>
> - Designing a hybrid monitoring architecture that scales across Azure, on-premises, edge, and multi-cloud using Azure Arc
>
> - Implementing service-centric monitoring with Azure Monitor Health Models, shifting from resource alerts to meaningful service health
>
> - Turning raw telemetry into actionable health signals using logs, metrics, workbooks, and health states
>
> - Avoiding alert fatigue and legacy monitoring mistakes, including the patterns many of us learned (the hard way) in the SCOM era
>
> Understanding cost, data ingestion trade-offs, and operational impact when monitoring environments Microsoft doesn’t host
>
> Expect real-world guidance, architectural patterns, and hard-earned lessons—not just feature walkthroughs. This session is built for IT Pros and cloud operators who need monitoring to work everywhere, not just where Azure happens to run.

## Baseline comparison

| Retained | Changed | Added | Removed from main route |
|---|---|---|---|
| Hybrid collection, Azure Monitor, Log Analytics, Health Models, SCOM lessons, alert fatigue, cost | Opening and sequence now follow customer outcome → evidence → model → investigation → response → recovery | Real coworker discussion, service view, impact, evidence freshness/Unknown, two-plane evidence contract, explicit recovery proof | Product-first sequence and alert-as-destination framing |

## Lab

The session's service was **IIC Hybrid Orders**, the same application as the Hybrid Operations session, deployed across Azure, the on-premises private cloud and AWS. Its design is in `lab/design/HYBRID-APPLICATION-HEALTH-DESIGN.md`.

The lab used for the demos was torn down on 2 October 2026. The demos can be followed with the rehearsal captures in `demos/src/fixtures/`.

## Demonstrations

Five demos follow one IIC order through the operating loop: M01 checks the evidence routes (DCR associations and machine heartbeats for the AWS machines, and the direct-ingestion rule for stage records); M02 reads the service view and the order's correlated stage records; M03 investigates the `marvin` fault on the AWS fulfillment worker and, later, verifies recovery with a fresh order; M04 reads the Health Model's configuration and explains its current state; M05 checks evidence freshness and cost by table. Without the lab, use the prepared fixtures. See [demos/README.md](demos/README.md) and the [interactive console](demos/demo-console.html).

Microsoft Sentinel, edge locations and security analytics are not part of this session. The Multicloud connector is mentioned where AWS is connected; AWS onboarding demonstrations belong to the complementary Hybrid Operations session.
