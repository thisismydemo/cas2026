# Hybrid operations: desk playbook

CAS26 | Kristopher Turner | September 2026

## Before you change anything

Name the **service, target, owner, evidence time and acting identity**. If one is unknown, investigate that gap before choosing a correction.

## Five questions, one practice each

| Section and question | Practice | Owner | Next action | Evidence |
|---|---|---|---|---|
| **Observe:** Is it working, and where do you look? | One place to look; alert on the order outcome, not the machine | Service owner + monitoring team | Build one service view and one outcome alert | A fresh order shows in it |
| **Secure:** Who is allowed to change it, and how is it protected? | The three key rules for people, machines and fix-up tools, plus Defender coverage | Security lead | List every identity that can change a server and check it against the rules | Review record and coverage report |
| **Govern:** Which team owns it, and does it stay the way we agreed? | Landing zone placement, Policy against a compliance standard, one patch process | Governance lead + platform team | Place Arc resources in the designed scope, assign a standard, tag every server with its patch ring | Compliance dashboard and ring results |
| **Cost:** What does it cost, and how do we keep it in check? | Tag everything, attest Software Assurance, set budgets | FinOps + service owner | Enforce tags with Policy, attest Software Assurance, create a budget per service | Cost by service and owner |
| **Adopt:** Did the fix work, and what do we keep doing? | Let the system fix things only with a proof step | Service owner | Pick one fix to hand to the system and define how it is verified | A fresh order after every change it makes |

## Who holds which key: three rules

- **People:** read-only by default; admin only when asked for, for a limited time, after MFA (PIM).
- **Machines and apps:** their own identity, only the permissions they need, no stored passwords.
- **Fix-up tools:** change one thing, in one place, and every change is logged.

Four independent doors, four keys: Azure (an Azure role), sign in (the server's own accounts), hosting (SCVMM or AWS admin), app + data (the app's own permissions). Run Command or extension rights are admin inside the server.

## Pick the right place to ask

- **Resource Graph:** what exists: resource IDs, tags, placement and reported configuration or state.
- **Log Analytics / KQL:** what happened: events, Syslog, heartbeats, application records.
- **Metrics / PromQL:** how a number is trending; Prometheus-compatible metrics live in an Azure Monitor workspace.
- **A fresh order:** whether the service works now. Pair it with the stores above.

Agent + DCR = data; no DCR, no data. **Check the service, not just the servers.**

<!-- pagebreak -->

## Letting the system fix things

| Level | Who acts | Example |
|---|---|---|
| Report only | A person reviews; nothing changes on its own | Policy compliance report |
| Fix with approval | The system proposes; a person approves | Policy remediation task, an approved patch ring |
| Fixes continuously | The system corrects drift on its own | Flux on the EKS cluster |

Every level ends in the same check: **verify the resource and the service.** Failed: stop the next step, restore where possible, escalate. Passed: close it and record the evidence. Before the system fixes anything, name the **owner, permissions, blast radius, when to stop, and how you prove it.**

## What to unlearn

| Section and assumption | Check instead |
|---|---|
| **Observe:** A heartbeat means it works | Run a fresh order |
| **Secure:** Connected means secured | Who holds which key, and Defender coverage |
| **Govern:** An assignment means compliance | Evaluation and remediation |
| **Cost:** No bill means free | The meter, the licence benefit and the allocation |
| **Adopt:** A finished task means recovery | Verify the outcome |

## Your first thirty days

- **Week 1:** inventory and owners (Govern).
- **Week 2:** access and the key rules (Secure); placement and Policy with a standard (Govern).
- **Week 3:** one service view and one alert on the outcome (Observe).
- **Week 4:** tags and budgets (Cost); one fix the system makes for you, proved by a fresh order (Adopt).

Start with one service and repeat the pattern.

## Make every alert actionable

Service/customer impact: ______________________________________

Evidence and time window: ____________________________________

Owner and escalation contact: _________________________________

Permitted action and scope: ___________________________________

Recovery evidence and stop condition: __________________________

See the **session companion** for diagrams, worked examples and references: query patterns in Appendix B, the service operating contract in Appendix C.
