# Whole-Service Observability — attendee explanations

## Slide 1: Monitoring What Microsoft Doesn't Host

This session is about observing a complete service rather than a single site. The example service runs across Azure, AWS and an on-premises private cloud, and the goal is one view of its health that follows the service through all three places. The session builds that view step by step, from evidence routes to a health model and a verified recovery.

## Slide 2: Thank you to our sponsors

The event is made possible by its sponsors, shown on the organizer's sponsor slide. Their support keeps community conferences like this one running and open to the people who attend them. The final sponsor artwork is supplied by the event organizer.

## Slide 3: About Kristopher Turner

Kristopher Turner presents this session. Their work focuses on hybrid operations across Azure, on-premises private clouds and AWS. The examples come from a real environment built for the event.

## Slide 4: Have you had discussions like this?

The session opens with a real team meeting. The presenter's team runs the lab environments, some of them treated as production. A corporate monitoring solution is shared with lab environments other teams manage, so the team receives a flood of alerts for things it does not own. In the meeting someone proposed another monitoring solution just for the team's own labs, and the thinking stayed on-premises, across the two datacenters, even though the labs already extend into Azure and AWS. The presenter's pushback was that the team needed more than monitoring: it needed observability, starting from the whole service rather than one site, with the Azure and AWS parts in the same single pane of glass from the start. The rest of the session is that answer, worked through on one example service.

Sources:
Presenter account of the team meeting (anonymised).

## Slide 5: What I asked the team to consider

The meeting proposed a monitoring tool for the team's on-premises labs: is the server up, across two datacenters, as another source of alerts. The presenter asked the team to consider a bigger question with the same data: can the people using our labs do their work right now, and if not, why not? That question covers every lab wherever it runs (on-premises, Azure, AWS), in one single pane of glass, and ends with impact, an owner and proof of recovery. This is the session's working definition of observability: understanding the health, dependencies and impact of a whole service from its evidence, then using that to investigate, act and prove recovery. Most estates are hybrid (Flexera 2026: 73% hybrid, 88% more than one cloud), so the whole service is almost always in more than one place. Monitoring tells you a server is up; observability tells you whether the customer was served, wherever the service runs.

Sources:
Presenter account of the team meeting (anonymised).
Flexera 2026 State of the Cloud (presenter-verified figures).

## Slide 6: Monitoring vs. observability

Monitoring and observability are often used as synonyms. In this session they mean different things. Monitoring collects and presents signals: it builds views, applies thresholds and raises alerts. Observability uses those signals to explain and operate a service: it knows the service boundary, the dependencies, the impact on customers, the owner, a bounded action and a verified recovery.

The link between them is context. The same measurements become explanatory when they carry enough information to say which service, which dependency and which customer operation they describe. Monitoring is a prerequisite, not a lesser form. Observability depends on good measurements and adds what is needed to reach a decision and prove its result. The line under the two columns maps each piece of that definition to the section of the session that builds it, so the six sections are the definition proved on one example service.

## Slide 7: Everything observability can be

An observability practice can grow into twenty areas: infrastructure, cloud platforms, application performance, distributed tracing, logs, metrics and telemetry, network, digital experience, databases and data platforms, Kubernetes and containers, security, availability and reliability, alerting and events, incidents and operations, dashboards and reporting, automation and remediation, configuration and assets, integrations, governance, and the platform architecture itself. In one sentence: metrics, logs, traces, events, topology, user experience and security telemetry, connected to alerting, dashboards, incident response, automation, governance and reporting, across on-premises, private cloud, public cloud, edge and hybrid. This session walks eleven of the twenty on one real-shaped service, IIC Hybrid Orders; the other nine are part of the practice but not today. The field manual carries the same map as an appendix, marked covered today, next and later. Each tile on the slide names the area's main items; the field manual appendix lists what every area includes in full, with its status for this session.

Sources:
Composite of common observability-platform capability lists (presenter-supplied, 2026-10-01).

## Slide 8: What we'll cover

The session has six sections, each built on one example service, IIC Hybrid Orders, and each answering part of the meeting the session opened with. One defines the service and what working means. Two shows how the parts Microsoft doesn't host become visible to Azure Monitor. Three follows a failing order from the customer down. Four turns evidence into health with Azure Monitor Health Models. Five covers alerts with context and proving recovery with fresh orders. Six covers what the evidence costs and how to keep the view useful. Each section has its own colour; every slide in a section carries that colour as a tag in its title band, and each section opens with an intro slide and includes a demonstration.

Sources:
Session structure.

## Slide 9: 1 · Define the service

Section 1 of 6, Define the service, answers one question: What does our example service depend on, and what does "working" mean? It covers the three customer commitments, the architecture across Azure, on-premises and AWS, and what one order depends on. It is here because you can't monitor a service until you have agreed what it is and what success looks like. Its part of observability is service boundary and dependencies. The section opens with this intro slide so you know the question before the content, and every slide in it carries the same colour tag in its title band.

Sources:
Session structure (agenda slide).

## Slide 10: What "working" means

The example application is IIC Hybrid Orders. Infinite Improbability Corp is fictional, but the services are real: Azure Front Door, Azure Container Apps, Azure Functions and Azure Service Bus, Amazon EKS and EC2, and a Linux worker on an on-premises private cloud. The application runs across all three environments.

Before collecting any data, the session defines what working means as three commitments. Customers can open the portal, proven by a response from either the Azure or the AWS portal origin. Customers can complete an order, proven by an order that completes inside its time target. Operators can observe the service, proven by fresh evidence arriving from every cloud. Working is a customer outcome with a time target, not a server that shows green. These commitments later become the top level of the health model. The order commitment is measurable: an order must complete within 45 seconds, the coordinator's configured timeout, with both workers answering.

Sources:
https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/health-modeling

## Slide 11: IIC Hybrid Orders architecture

IIC Hybrid Orders spans three boundaries. In Azure, Front Door with a WAF policy is the public entry point and routes customers to one of two portal copies: one on Azure Container Apps and one on an Amazon EKS cluster behind an AWS Application Load Balancer. Both portals call an Azure Functions coordinator, which assigns a correlation ID and places work on Azure Service Bus. An on-premises validation worker on an SCVMM-managed Hyper-V VM and an AWS fulfillment worker on EC2 pull that work over outbound TLS, with no inbound publication and no cross-cloud VPN.

The order completes only when both workers answer, so AWS is inside the order path. The monitoring behind the application is covered in section 2, one evidence route at a time.

Sources:
https://learn.microsoft.com/en-us/azure/frontdoor/front-door-overview
https://learn.microsoft.com/en-us/azure/service-bus-messaging/service-bus-messaging-overview
https://learn.microsoft.com/en-us/azure/azure-arc/multicloud-connector/overview
https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview
https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/overview

## Slide 12: What an order depends on

This slide answers the first half of the section question: what does one order depend on, and which of those parts are required? An IIC order passes through a portal (served from either Azure Container Apps or EKS in AWS), the coordinator (Azure Functions with Service Bus), the validation worker on-premises and the fulfillment worker in AWS. Every part after the customer is required: the coordinator waits for both workers, so there is no optional step.

A dependency is part of the service definition. If any one of these parts is missing there is no order, so the service has to be defined as the whole chain, four parts in three places, rather than as the servers in one estate. Two of the four required parts are not hosted by Microsoft. What happens when a required part fails is shown in section 3 with a controlled fault on the AWS worker.

## Slide 13: 2 · See the parts Microsoft doesn't host

Section 2 of 6, See the parts Microsoft doesn't host, answers one question: The architecture shows what should exist. Can we actually see every part of it? It covers how Azure Arc makes an on-premises or AWS machine visible to Azure Monitor, where the evidence lands, and how one order is followed across all three places by one ID. It is here because a server connected to Arc is not the same as evidence arriving, and every later view depends on it. Its part of observability is the evidence that everything else depends on. The section opens with this intro slide so you know the question before the content, and every slide in it carries the same colour tag in its title band.

Sources:
Session structure (agenda slide).

## Slide 14: How a machine anywhere becomes visible

Each part of the service becomes visible to Azure Monitor the same way. The coordinator in Azure is already an Azure resource. The on-premises validation worker and the AWS fulfillment worker become Azure resources through Azure Arc, which gives each machine an identity in Azure but no evidence by itself. The Azure Monitor Agent then sends heartbeat, performance and log data, and each worker sends a record for every order stage it handles. Everything lands in one Log Analytics workspace, so evidence from Azure, on-premises and AWS sits side by side. The configuration behind this (data collection rules, associations, the logs ingestion API, managed identities and the roles they need) is in the field manual. The check that matters: connected is not the same as collected, so confirm evidence is arriving from every part, every day.

Sources:
lab/design/HYBRID-APPLICATION-HEALTH-DESIGN.md, collection section
Microsoft Learn: Azure Arc-enabled servers overview
Microsoft Learn: Azure Monitor Agent overview
Microsoft Learn: Logs ingestion API

## Slide 15: One order, one ID

In IIC Hybrid Orders, every stage of an order writes one record to the Cas26Service_CL table with the same CorrelationId, a GUID assigned by the coordinator. The customer-visible order number, such as IIC-000042, is for display only. An order's timeline reads: the portal origin that served the customer, the coordinator accepting the order, the on-premises worker validating it, the AWS worker fulfilling it, and the coordinator completing it.

Each record carries the cloud, component, stage, success flag and duration, so a single query filtered on the correlation ID shows which environment was slow or failed. The order is complete only when the coordinator writes a successful Completed record, and any failed stage fails the order.

Sources:
https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview
https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview

## Slide 16: DEMO: Evidence routes

This demonstration, runbook M01, proves each evidence route instead of assuming it from Arc registration. It selects the machines and a time window, confirms that each machine has the expected data collection rule association, queries Heartbeat and Perf for the Arc-connected AWS machines, checks the direct-ingestion route for stage records into Cas26Service_CL, and verifies freshness and the identity used.

A route is proven when the expected resource appears with a current timestamp in the expected destination. Typical failures are a missing association, the wrong scope, stale data or a query the identity is not authorised to run, and each points to a different fix.

Sources:
https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-associations
https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview
https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview
https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-ingestion-time

## Slide 17: 3 · When an order fails

Section 3 of 6, When an order fails, answers one question: When an order fails, where do we look first? It covers why a healthy server can hide a failing service, how to read the service view, a baseline order, a controlled fault in AWS, and investigating from the customer down. It is here because a green server can hide a failing service, so investigation has to start from the customer. Its part of observability is impact, explained from the customer down. The section opens with this intro slide so you know the question before the content, and every slide in it carries the same colour tag in its title band.

Sources:
Session structure (agenda slide).

## Slide 18: Resource view vs. service view

A view of one resource answers questions about that resource. In the example, the on-premises validation worker shows normal CPU and a fresh heartbeat, and both are accurate. The same view cannot say whether orders completed, which portal origin served customers, or whether the AWS fulfillment worker is answering, and the customer outcome depends on all three.

A whole-service view brings together the customer outcome, both portal origins, both workers, the freshness of each evidence source and the owner of each part, because it reads evidence from every environment the order passes through. Resource views remain useful for component owners. They should not be used as the answer to a question about the whole service.

## Slide 19: Reading the service view

A service view is easier to use under pressure when everyone reads it in the same order. First, the customer outcome: order success, latency against the target and the last good order. Second, overall health: the modelled state, the freshness of its evidence and the affected commitment. Third, the components and dependencies, such as both portal origins, the coordinator and both workers. Fourth, evidence freshness: the latest timestamp per source and any late sources, which make that part of the view unknown rather than healthy. Fifth, drill-down from a correlation ID to the signal that changed state, its owner and its runbook.

The workbook presents this information; it does not calculate health. The health state comes from the Azure Monitor health model, and the workbook places it next to the raw evidence. The health states shown in this view come from the Azure Monitor health model, which the session explains in detail later.

Sources:
https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/workbooks-overview
https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/overview

## Slide 20: DEMO: Baseline order (1 of 2)

This demonstration, stage 1 of runbook M02, places one healthy baseline order. A single demo-tagged order is sent through the Front Door endpoint, and its correlation ID, time and serving portal origin are recorded. Its stage records are then read from Cas26Service_CL by that correlation ID, and the same order is located in the service workbook.

The evidence must show an order that completed inside its time target, every stage present across Azure, on-premises and AWS, and a workbook with fresh data. The baseline is the comparison point for the later fault and for proving recovery with a new order.

Sources:
https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview
https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/workbooks-overview

## Slide 21: DEMO: Service view (2 of 2)

This demonstration, stage 2 of runbook M02, reads the service view around the baseline order. The view is read in a fixed order: customer outcome, overall health, components and dependencies, evidence freshness and drill-down. The baseline order's stages are opened by correlation ID and compared with the raw records, both portal origins are checked, and the freshness and owner of each source are noted.

The evidence must show that the outcome, component states and freshness in the view agree with the raw stage records. When they disagree, the raw records win and the view needs fixing.

Sources:
https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/workbooks-overview
https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/overview
https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/concepts

## Slide 22: Impact-first investigation

A reliable investigation starts from customer impact and narrows toward specific evidence. First, confirm the impact: which operation is affected and since when. Second, scope a failing order by its correlation ID and the resources involved. Third, compare its stage records across the coordinator, the on-premises worker and the AWS worker, and against a healthy baseline order. Fourth, inspect the dependencies, including the modelled health of the relevant branch and the freshness of its evidence. Fifth, decide on an owner and a bounded action.

At each step, the claim should go no further than the evidence supports. Two observations that appear together are not a cause; a cause needs a test or further evidence that connects them. An investigation must separate a failed component from lost visibility: a Failed stage record with fresh heartbeats points at the worker, while a missing stage record calls for checking dispatch and the queue before concluding that visibility was lost.

Sources:
https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/concepts

## Slide 23: DEMO: Controlled fault

This demonstration injects a controlled, reversible fault into the IIC Hybrid Orders application. The AWS fulfillment worker is set to Fail mode, fault name marvin, by writing one CAS26-owned state file. The fault applies only to orders placed with the demo tag, and it never stops a service, machine or host.

A fresh demo-tagged order is then placed and its stage records are read by correlation ID. The expected evidence is a failed AWS stage with FailureMode marvin, a failed order, and worker heartbeats that remain fresh. Because the AWS worker is a required part of the order path, its failure is the cause of the failed order, and the correlated records show it. Healthy machines did not mean a working service.

The fault is cleared later, and recovery is proven with a new order. The fault, named marvin, is a demo-only switch on the AWS worker: it fails only demo-tagged orders and expires automatically.

Sources:
https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-query-overview
https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview

## Slide 24: 4 · Model health with Azure Monitor Health Models

Section 4 of 6, Model health with Azure Monitor Health Models, answers one question: How does evidence become a health state the whole team can trust? It covers sCOM's service model reintroduced for a hybrid estate; what a health model is made of; how health rolls up; what happens when evidence goes quiet; the live IIC model. It is here because a health model turns records into one answer about the service, instead of a wall of alerts. Its part of observability is explanation the whole team can trust. The section opens with this intro slide so you know the question before the content, and every slide in it carries the same colour tag in its title band.

Sources:
Session structure (agenda slide).

## Slide 25: SCOM's idea, reintroduced

If you ran System Center Operations Manager, you already modelled services: a distributed application grouped components, monitors watched events and counters, and health rolled up from the components to the service. Azure Monitor Health Models reintroduces that idea for a hybrid estate. The service is a health model, one Azure resource. The parts are entities, which can be Azure resources, Arc-enabled machines in your datacenter or in AWS, or connector resources. Signals read data Azure Monitor already collects, so there are no management packs. Health propagates from entities to the service. What is different: it uses existing data, missing data is a designed state (Unknown) rather than an error, it raises one alert per state change instead of one per monitor, and it is still in preview.

Sources:
Microsoft Learn: Azure Monitor Health Models overview (preview)
Microsoft Learn: SCOM distributed applications

## Slide 26: What a health model is made of

A health model has four layers: the service (the outcome being protected), its commitments and components (the entities), the signals that measure each entity, and the state those signals produce. One signal end to end for the AWS fulfillment entity: the evidence is stage success and latency from the order records; the window is a lookback period with enough samples; the rule is a pair of thresholds on the failure rate, one for Degraded and one for Unhealthy; the result is a state of Healthy, Degraded, Unhealthy or Unknown. Every coloured state must trace back to a signal, a window and a rule, or nobody can explain it. The service view shows results; the model defines what they mean.

Sources:
lab/design/HYBRID-APPLICATION-HEALTH-DESIGN.md, Health Model section
Live model hm-tplabs-cas26-service-cus-01
Microsoft Learn: Health Models signals

## Slide 27: How health rolls up

The live IIC model has nine entities under one root, IIC Hybrid Orders, which takes the worst state of its children. Under it are the three commitments. The portal has two origins, Container Apps in Azure and EKS in AWS, which are redundant (impact Limited): one origin down makes the commitment Degraded, not Unhealthy. Completing an order needs the coordinator, on-premises validation and AWS fulfillment, which are required (impact Standard): any one Unhealthy makes the commitment Unhealthy. Observing the service has its own signals on the stalest evidence source, and lost evidence makes it Unknown rather than down. The controlled fault from section 3 therefore reads: AWS fulfillment Unhealthy, the order commitment Unhealthy, the service Unhealthy. Deciding what is required and what is redundant is how health rolls up.

Sources:
Live model hm-tplabs-cas26-service-cus-01 read back 2026-10-01
Microsoft Learn: Health Models entity impact and aggregation (Microsoft.CloudHealth 2026-05-01-preview)

## Slide 28: When evidence goes quiet

Before a rule runs, a health model should ask whether the evidence is fresh and whether there is enough of it. If so, it evaluates the rule and produces a known state; if not, the state is Unknown, which is never Healthy. No evidence is not good news. For estates with several datacenters and branch or edge sites, each site is its own entity under one parent. A disconnected site shows Unknown, and with a threshold rule on the parent (Unhealthy only if more than half the sites are unhealthy; Unknown sites ignored by default) the remaining sites keep the commitment healthy. The service also tracks its stalest evidence source and alerts when one goes quiet. Unknown is an operating state, not another shade of green.

Sources:
Microsoft Learn: Health Models signal evaluation and Unknown
Live observability entity signal (Degraded above 5 min, Unhealthy above 15 min)

## Slide 29: DEMO: Model configuration (1 of 2)

This demonstration reads a health model's configuration in a fixed order: the model, its entities and relationship direction, one signal's query, window and thresholds, and finally the aggregation and missing-data behaviour. The goal is that every coloured state can be traced to a named signal and rule.

In the lab, the health model hm-tplabs-cas26-service-cus-01 holds the full IIC Hybrid Orders tree: the service, its three commitments and their components.

A useful review habit: if any threshold cannot be explained in one sentence, or any state has no signal behind it, record that as a gap in the model.

Sources:
https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/designer
https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/signals
https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/rollup

## Slide 30: DEMO: Current state (2 of 2)

This demonstration explains a health model's current state from evidence upward. It starts with current stage records and their timestamps, evaluates the signal's rule against them, follows aggregation to the commitment, and traces propagation to the service. In the IIC design, failed AWS stages with FailureMode marvin explain an Unhealthy AWS fulfillment entity, which makes the commitment that customers can complete an order Unhealthy.

A complete explanation states four things: the state, the evidence behind it, the evaluation window, and the limits of what the state proves. If evidence is stale or insufficient, the correct answer is Unknown rather than a forced colour. Before reading the live state, predict it: with the marvin fault, AWS fulfillment is Unhealthy, its Standard impact makes the order commitment Unhealthy, and the root, using Worst of, becomes Unhealthy. The demonstration then checks the prediction against the evidence.

Sources:
https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/analyze-health
https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/signals
https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-query-overview

## Slide 31: 5 · Respond and prove recovery

Section 5 of 6, Respond and prove recovery, answers one question: Who acts, and how do we prove the service recovered? It covers alerts that carry context instead of alert sprawl, and recovery proven with fresh orders rather than a closed ticket. It is here because an alert only starts the work; recovery is a new observation, not a closed ticket. Its part of observability is owner, bounded action, verified recovery. The section opens with this intro slide so you know the question before the content, and every slide in it carries the same colour tag in its title band.

Sources:
Session structure (agenda slide).

## Slide 32: Alerts with context

An alert is useful when it carries context to an accountable owner. The condition should be meaningful, such as a customer commitment or signal changing state, rather than every resource threshold. The alert should carry the service, component, evidence, freshness and a correlation ID so the responder can start from the affected order. It should reach a named owner with the permission to act and a runbook.

The alert starts work; it is not the outcome. The outcome is a verified recovery of the service.

A configured alert rule does not prove that a notification was delivered. Action groups should be tested end to end. Azure Monitor health model alerts fire on entity state changes and use the same action groups as other Azure Monitor alerts.

Alert fatigue is shown here, not only named. The controlled AWS fault from earlier in the session could, without a health model, trigger several independent per-signal alerts for one root cause: a stage-failure query, a queue-depth threshold, a latency threshold, none carrying the others' context. With the health model, one entity alert on the order commitment fires once per state change instead, through the same action group, and resolves itself when the entity is healthy again. Existing resource alert rules keep firing until they are disabled. When moving to health model alerts, run the old rules and the new entity alert side by side, then retire each old rule once the entity alert has proven itself. The owner is also the answer to alert noise from systems other teams manage: an alert that carries an owner goes to the team that can act, and an alert with no owner is not yours. Before: a flood of alerts plus three separate rules for one fault. After: one entity alert on the commitment, with a named owner, that fires once per state change and resolves itself.

Sources:
https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview
https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/action-groups
https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/alerts

## Slide 33: Recovery is a new observation

Recovery follows one loop: see it (the service view says an order commitment is Unhealthy), explain it (the model names the entity and the signal), fix it (one bounded change by the owner of that part), prove it (fresh orders complete and nothing is left waiting in the queue), and watch it catch up (the model and the alert recover later). Four clocks are involved: the order result, the record arriving in the workspace (typically 30 seconds to 2 minutes on the agent route), the model re-evaluating on its window, and the alert resolving on its frequency, which for log search alerts ranges from one minute to 24 hours. Capture a timestamp at every layer. The fulfillment owner makes the change; the service owner declares the service recovered. A successful command proves execution, not customer recovery.

Sources:
Microsoft Learn: Azure Monitor Agent ingestion latency
Microsoft Learn: log search alert rule frequency (1 minute to 24 hours)
Demo runbook M03 stage 2

## Slide 34: DEMO: Recovery

This demonstration completes the controlled fault runbook. The AWS worker is set back to Healthy, which proves only that the setting changed. A new demo-tagged order is then placed, and its stage records must show every stage present and the order completed, under a new correlation ID.

After that, the health model and alert catch up on their own schedules: AWS fulfillment returns to Healthy, the order-completion commitment follows, and the alert resolves. The expected evidence is the new correlation ID, the completed order, and the later model and alert states with their timestamps.

Recovery is a new observation, not a reused success screenshot. The fault affected demo-tagged orders only. The recovery demonstration places several new orders and checks that all complete and nothing is left waiting in the queue before checking the model and the alert.

Sources:
https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/analyze-health
https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview
https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-ingestion-time

## Slide 35: 6 · Keep it affordable and useful

Section 6 of 6, Keep it affordable and useful, answers one question: What does the evidence cost, and how do we keep the view useful? It covers coverage, volume and retention trade-offs with real lab numbers; the freshness-and-cost demo; the operating cycle, including collecting the same thing twice. It is here because observability nobody can afford or maintain decays; every signal needs a question and an owner. Its part of observability is keeping it true over time. The section opens with this intro slide so you know the question before the content, and every slide in it carries the same colour tag in its title band.

Sources:
Session structure (agenda slide).

## Slide 36: Evidence trade-offs

Evidence involves a trade-off between coverage (the questions that can be answered), volume and cost, and retention. The main Azure Monitor meters are Log Analytics ingestion per GB, which varies by table plan (Analytics, Basic or Auxiliary); retention beyond the included period, billed per GB per month; Azure Monitor workspace metrics, billed by samples ingested and queried; and alert rules, billed by rule type and the number of time series monitored. Basic and Auxiliary plans lower ingestion cost but add query charges and limit features.

Current prices change and vary by region, so check the Azure Monitor pricing page before estimating money.

A decision record keeps reductions safe: for each signal, record the question it answers, its owner, grain, retention, the meter it affects, and the blind spot accepted if it is reduced. In the lab, seven days of data came to 8.1 GB of billable ingestion, led by Perf (1.41 GB), AppTraces (1.25 GB) and ContainerInventory (1.21 GB), while the order stage records that answer the customer question were only 0.011 GB. Cost decisions should start with the high-volume tables, not with the evidence that answers the service question.

Sources:
https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/cost-usage
https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/cost-meters
https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs
https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs
https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure

## Slide 37: Keeping it useful

A service view stays useful only through an explicit operating cycle. Inventory the expected sources and their cadences. Measure volume and freshness on a schedule. Tune signals, windows and routes, including thresholds that are too noisy or never fire. Review alert noise and any customer impact that monitoring missed. Keep owners, runbooks and escalation paths current.

The cycle should repeat whenever the architecture, owners or expectations change, for example when a new cloud origin or worker is added to the service.

Retirement is part of the cycle: stale queries, unused tables, orphaned alert rules and legacy agents add cost and confusion if left in place. Coverage, tuning and ownership are ongoing maintenance work, not a one-time project. The most common waste is the same source collected by two overlapping routes, which produces duplicated records, conflicting charts and double alerts; inventory the routes before adding another one.

Sources:
https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/best-practices-cost
https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/health-modeling
https://learn.microsoft.com/en-us/azure/azure-monitor/logs/analyze-usage

## Slide 38: DEMO: Freshness and cost

This demonstration checks evidence freshness and cost boundaries. It queries the most recent timestamp for each source and stage, for example Heartbeat and Perf from Arc-connected machines and the newest application stage records, and compares each with its expected cadence. Silence has several possible causes: no traffic, wrong scope, collection failure, route failure or an unavailable component.

It then summarises billable volume by table using the workspace Usage data, and records one reduction decision: the signal, the question it answers, its owner, grain, retention, meter and the blind spot accepted.

The expected evidence is freshness per source, volume by table and one recorded decision.

Sources:
https://learn.microsoft.com/en-us/azure/azure-monitor/logs/analyze-usage
https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-ingestion-time
https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs

## Slide 39: Back to that meeting

The session opened with a team meeting that proposed a new monitoring tool just for the team's labs, starting on-premises across two datacenters. The answer, with what the session showed: define the service first (a lab, like an order, needs parts in more than one place); see every part (Azure Arc put the AWS and on-premises workers in the same workspace as Azure, one single pane of glass, and the evidence was proved to arrive); read impact from the people using it down (in the controlled fault the machines were healthy while every order failed); prove recovery with fresh evidence and let the dashboards catch up. IIC Hybrid Orders was the stand-in; the labs are the same shape. Same data, bigger question. Monitoring tells you a server is up; observability tells you whether the customer was served, wherever the service runs.

Sources:
Session structure.

## Slide 40: Let's keep the conversation going.

The session materials are in the presenter's public repository. It holds the handouts, the KQL queries, the five demonstration runbooks and the IIC Hybrid Orders design. The contact details on the slide are the best way to follow up.

## Slide 41: Other sessions worth attending

Three related sessions, all in Clarity, Central time: Thursday October 1 at 1:15 PM, From On-Prem to Cloud-Native (John Smith); Thursday October 1 at 3:00 PM, Engineering for Reliability and Stability in the Azure Messaging Services (Eldert Grootenboer); Friday October 2 at 3:00 PM, Integrate Azure Monitor alerts from servers with your ITSM system (John Joyner). Check the current event schedule, as rooms and times can change.

## Slide 42: A sponsor worth a visit: StratoLens

StratoLens is a sponsor of Cloud & AI Summit 2026 whose product is on this session's topic for the Azure side of an estate. In their words: change observability for Azure, self-hosted in your own tenant and deployed from the Azure Marketplace in under 15 minutes, with change tracking (what changed, who changed it and when), cost anomaly detection and orphaned resources, access optimisation for stale and over-privileged role assignments, network topology and Azure Policy change tracking. Where it fits this session: the change, cost and access half of the evidence, on the Azure side; it is Azure only today, and this session also covered AWS and on-premises. Observability is a practice, not one product. Details: getstratolens.com and the event's sponsor page.

Sources:
cloudandaisummit.com sponsor detail page for StratoLens (read 2026-10-01)
getstratolens.com (read 2026-10-01)

## Slide 43: Questions?

The closing discussion asks attendees which part of their estate is hardest to see or explain. Useful ways to frame any answer: name the customer commitment involved, the evidence that exists for it, how fresh that evidence is, and who owns the response.

## Slide 44: Thank you — feedback & resources

Thank you for attending this session on whole-service observability. Feedback for this session can be left through the QR code on the slide. All materials, including the handouts, queries, runbooks and the IIC Hybrid Orders design, are in the repository at github.com/thisismydemo/cas26.

