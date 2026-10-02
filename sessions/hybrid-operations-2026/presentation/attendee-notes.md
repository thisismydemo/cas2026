# Hybrid Operations — attendee explanations

## Slide 1: Hybrid Operations in 2026

Hybrid Operations in 2026 examines how to operate workloads across Azure, on-premises infrastructure, and other clouds with consistent ownership and evidence. Azure Arc supplies a management connection for supported resources outside Azure. Monitoring, security, governance, cost management, and automation then build on that connection.

The session follows the same resources through several operating questions. This makes it possible to distinguish connecting a resource from proving that it is monitored, protected, compliant, and delivering its intended service. The complementary observability session provides deeper implementation guidance for telemetry and service health.

## Slide 2: Thank you to our sponsors

This slide acknowledges the event sponsors. Sponsor artwork is supplied by the event and does not establish which products are deployed in the demonstration environment. Technical claims and implementation references appear with the relevant session material.

## Slide 3: About Kristopher Turner

Kristopher Turner presents the session from an IT operations perspective. The central concern is how teams establish ownership, access, useful evidence, and repeatable action across a hybrid estate. Contact: kris@hybridsolutions.cloud. Use the accompanying repository and attendee materials for technical references and the demonstration context.

## Slide 4: Hybrid stayed. The operating model has to catch up.

Hybrid is the normal operating condition, not a temporary phase. Most organizations run workloads in Azure, in their own datacenters, in at least one other public cloud, at edge or remote sites, and on older systems that are hard to change.

Each location is operated differently, so each operating question has several answers. Which team owns it? Different teams per location. Is it working, and where do you look? Azure Monitor, System Center or VMware consoles, CloudWatch, local tools, or old agents. Who is allowed to change it? Azure RBAC, Active Directory groups and hypervisor roles, AWS IAM, or local administrator accounts. What does it cost? Different invoices and budgets.

Each of these questions is answered by a section of the session (Govern, Observe, Secure and Cost); a fifth section asks whether the fix worked. The session builds one consistent way to answer each across the estate.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/overview

## Slide 5: What we’ll cover and demonstrate

The session connects five operating outcomes: monitoring, security, governance and identity, cost and impact, and practical operations patterns. Azure Arc provides the management foundation that lets these outcomes be applied to supported resources running outside Azure.

Demonstrations follow a deliberate progression. Server onboarding establishes a resource representation. Arc-enabled SCVMM-hosted workloads illustrate on-premises operations. AWS onboarding is followed later by management of the same EC2 and EKS resources. Monitoring, access, security, and Policy examples use this shared context rather than a different unexplained environment for each product.

Both sessions share one Azure landing-zone placement and security baseline. The SCVMM platform is already connected to Azure Arc, so its onboarding is explained as architecture rather than demonstrated live. Health Models is covered at overview level here, with implementation depth reserved for the observability session. Governing and managing efficiently includes one update process for Azure, on-premises and AWS servers, with Azure Update Manager and Extended Security Updates for end-of-support Windows Server.

## Slide 6: Azure Arc extends Azure management to resources running elsewhere.

Azure Arc extends Azure management to supported infrastructure and applications outside Azure. The managed workload remains where it already runs. Its Azure representation gives Azure services a resource identity and a supported management target.

For a server, Arc can provide the foundation for Azure-based inventory, role assignments, extensions, and selected monitoring, security, and governance capabilities. Those capabilities require their own configuration. A visible Arc resource does not prove that logs are collected, Defender coverage is active, Policy requirements are satisfied, or the application is healthy.

Arc also supports resource types beyond individual servers, including integrations with virtualization platforms and Kubernetes clusters. These use different onboarding mechanisms. The shared idea is an Azure management representation; the technical path depends on the resource type. Application traffic continues to use the application's network routes rather than flowing through Arc.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/overview
https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview

## Slide 7: Connecting a server to Arc

Connecting a server to Azure Arc installs the Azure Connected Machine agent on the machine. The agent makes a single outbound HTTPS connection (TCP 443) to Azure; no inbound ports or VPN are required, and application traffic does not use this connection.

The server appears as an Azure resource (Microsoft.HybridCompute/machines) in the subscription and resource group chosen at onboarding. That placement determines which Azure Policy assignments and role assignments it inherits.

Verify onboarding on both sides: azcmagent show on the machine reports Connected, and the matching resource appears in Azure in the intended scope. Monitoring, Defender for Cloud, Azure Policy and Update Manager are configured separately afterwards.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview
https://learn.microsoft.com/en-us/azure/azure-arc/servers/network-requirements

## Slide 8: DEMO: connect the on-premises/edge machines to Azure Arc

This demonstration establishes the Arc-enabled server connection for an owned machine. The intended result is agreement between local agent status and the Azure resource in the correct subscription and resource group. The relevant evidence includes the machine identity, Azure resource ID, placement, tags, and connection status.

The onboarding identity needs permission for the chosen scope. Credentials are not part of the attendee material. Production adoption should use the documented onboarding method and an appropriately scoped identity rather than copying an unrestricted administrator workflow.

The demonstration proves connection, not complete operational readiness. Monitoring data collection, security coverage, and Policy behavior must be verified independently. A command that returns successfully is weaker evidence than the paired local and Azure checks.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview
https://learn.microsoft.com/en-us/azure/azure-arc/servers/security-identity-authorization

## Slide 9: SCVMM and vCenter

Virtual machines are created and run by a virtualization manager: System Center Virtual Machine Manager (SCVMM) for Hyper-V, or VMware vCenter Server for vSphere. The manager creates, starts, stops and moves VMs and keeps an inventory of every VM, template and network on its hosts and clusters.

The Connected Machine agent connects one machine from inside its operating system. SCVMM or vCenter sees every VM from underneath, including VMs without an agent and VMs that are powered off. Azure Arc can connect to SCVMM (Arc-enabled SCVMM) or vCenter (Arc-enabled VMware vSphere) once, rather than to each VM.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/system-center-virtual-machine-manager/overview
https://learn.microsoft.com/en-us/azure/azure-arc/vmware-vsphere/overview

## Slide 10: Connect SCVMM or vCenter to Azure Arc

Arc-enabled SCVMM and Arc-enabled VMware vSphere share one architecture. An on-premises Arc resource bridge connects the management server (SCVMM or vCenter Server) to Azure. Requests from Azure, such as create, start, stop, resize or enable guest management, reach the platform through a custom location and the bridge; the bridge discovers the platform's inventory, and administrators enable the resources Azure should manage. Enabling guest management installs the Connected Machine agent in a running VM. VMware Cloud Director tenant access is not equivalent to the vCenter access this integration needs.

Arc-enabled SCVMM is retiring: new onboarding stops in October 2026 and the service ends in September 2029. Management-only use moves to Arc-enabled servers; VM lifecycle use should be discussed with Microsoft. Arc-enabled VMware vSphere is not affected.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/system-center-virtual-machine-manager/overview
https://learn.microsoft.com/en-us/azure/azure-arc/system-center-virtual-machine-manager/quickstart-connect-system-center-virtual-machine-manager-to-arc
https://learn.microsoft.com/en-us/azure/azure-arc/resource-bridge/overview

## Slide 11: Two ways to bring a VM into Arc

A virtual machine can be brought into Azure Arc in two ways. Inside the VM, the Connected Machine agent makes it an Arc-enabled server, which provides guest services such as monitoring, security and update management. Through the virtualization manager, Arc-enabled SCVMM or Arc-enabled VMware vSphere provides VM lifecycle operations (start, stop, create) through the Arc resource bridge and sees every VM in the managed environment.

Both can be used together; each VM remains a single Azure resource. Installing the agent on the SCVMM server connects only that server, not the VMs it manages.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/system-center-virtual-machine-manager/overview
https://learn.microsoft.com/en-us/azure/azure-arc/vmware-vsphere/overview

## Slide 12: The multicloud connector

The multicloud connector enabled by Azure Arc is an Azure resource that connects an AWS account or a GCP project to Azure. After read access is granted in the source cloud, it scans the account on a schedule; the connector itself is free, while services used with it are billed normally.

It offers three solutions. Inventory lists the source cloud's resources in Azure, where they can be queried with Azure Resource Graph and tagged. Arc onboarding for servers discovers EC2 instances or GCP VMs and installs the Connected Machine agent. Arc onboarding for Amazon EKS (preview) connects EKS clusters as Arc-enabled Kubernetes clusters. AWS support is generally available; GCP support is in preview.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/multicloud-connector/overview

## Slide 13: How the connector works

The multicloud connector works in four steps. First, grant Azure access to the other cloud: in AWS, a CloudFormation template creates an IAM role the connector uses; for GCP (preview), a Terraform script grants access. Second, the connector is an Azure resource that uses that access. Third, it brings resources in: the Inventory solution adds a read-only list of resources, server onboarding installs the Azure Connected Machine agent on EC2 instances through AWS Systems Manager (and on GCP VMs through OS Config, in preview), and EKS onboarding (preview) installs the Azure Arc Kubernetes agents. Fourth, each management service, such as Azure Policy, Azure Monitor, Update Manager or GitOps with Flux, is configured separately. A resource listed in Azure is not yet managed.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/multicloud-connector/overview

## Slide 14: Onboarding EC2 and EKS

When the multicloud connector onboards AWS resources, an EC2 instance and an EKS cluster become different Azure resources. For EC2, the connector installs the Azure Connected Machine agent through AWS Systems Manager, producing an Arc-enabled server (Microsoft.HybridCompute/machines) that can use services such as Azure Policy, Azure Monitor, Defender for Cloud and Update Manager. For EKS (preview), the connector installs the Azure Arc Kubernetes agents, producing an Arc-enabled Kubernetes cluster (Microsoft.Kubernetes/connectedClusters) that can use GitOps with Flux, Azure Policy and supported Kubernetes extensions. Each service is added separately; Arc does not convert EKS into AKS or take over AWS lifecycle management.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/multicloud-connector/overview

## Slide 15: DEMO: add AWS resources through the Arc multicloud connector

The AWS connector demonstration follows resources through authorization, discovery, and Arc onboarding. Each stage has its own evidence. A discovered item establishes inventory visibility; an operational Arc server or cluster connection establishes a different result.

For EC2, retain the source instance ID and matching Arc-enabled server resource ID. For EKS, retain the source cluster ARN and matching Arc-connected cluster ID. These mappings are reused in the later management demonstrations. They keep unrelated resources from being mistaken for the ones onboarded through the connector.

The shared landing-zone design must cover actual Azure placement, including connector-created resource groups, with the intended Policy, access, monitoring, and security configuration. AWS continues hosting the workloads. Onboarding is asynchronous, so each resource's state is read from current evidence rather than assumed from the connector's success.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/multicloud-connector/add-public-cloud
https://learn.microsoft.com/en-us/azure/azure-arc/multicloud-connector/onboard-multicloud-vms-arc
https://learn.microsoft.com/en-us/azure/azure-arc/multicloud-connector/onboard-elastic-kubernetes-service-clusters-arc

## Slide 16: Edge and legacy: Arc management still requires Azure connectivity

Edge sites keep running locally, but Azure Arc is not a disconnected management product: an Arc-enabled server needs outbound connectivity to Azure, directly, through a proxy, or through an Arc gateway, which reduces the endpoints to allow. If the connection is lost, the workload continues, but the status and evidence shown in Azure become stale until it reconnects.

For older servers, check the operating system version, agent requirements and outbound access before onboarding, and start with one machine. End-of-support Windows Server can receive Extended Security Updates enabled by Azure Arc.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/servers/network-requirements

## Slide 17: One pattern, four onboarding paths

Azure Arc uses the same pattern for every source: an agent is installed and an Azure resource represents the machine or cluster. What differs is who installs the agent. On-premises and edge servers are onboarded by installing the Connected Machine agent; the multicloud connector installs it on AWS EC2 through AWS Systems Manager and on GCP VMs through GCP OS Config (preview), and installs the Arc Kubernetes agents on Amazon EKS clusters (preview). Servers become Microsoft.HybridCompute/machines resources; EKS clusters become Microsoft.Kubernetes/connectedClusters resources.

The connector's Inventory solution alone creates read-only representations; only onboarding creates an Arc resource that can be managed.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview
https://learn.microsoft.com/en-us/azure/azure-arc/multicloud-connector/overview
https://learn.microsoft.com/en-us/azure/azure-arc/multicloud-connector/onboard-elastic-kubernetes-service-clusters-arc

## Slide 18: From managing to operating

The first part of the session made the estate manageable: on-premises servers, SCVMM-hosted VMs, AWS servers and an EKS cluster are connected to Azure and can be seen and managed in one place. The rest of the session is about operating the service that runs on that estate: keeping it working, protected, governed, affordable and improving, in five sections: Observe, Secure, Govern, Cost and Adopt. Managing the estate is not the same as running the service.

## Slide 19: Meet the service: IIC Hybrid Orders

Infinite Improbability Corp (IIC) is a fictional company used throughout the session; its IIC Hybrid Orders service is real and runs in the lab. A customer places an order in a web portal; the order is validated against a private enterprise system on-premises, fulfilled and priced in AWS, and completes only when both results arrive.

The pieces run in all three estates. Azure: Azure Front Door as the single public entry, the portal on Azure Container Apps, a coordinator on Azure Functions with Azure Service Bus queues, and Application Insights with Log Analytics. On-premises: the validation worker cas26-lnx01 on the SCVMM-managed hvcl-ral-t1 Hyper-V cluster. AWS: a second copy of the portal on Amazon EKS and the fulfillment and pricing worker on Amazon EC2. The remaining sections ask their operating questions about this service.

Sources:
lab/design/HYBRID-APPLICATION-HEALTH-DESIGN.md

## Slide 20: Arc made the estate manageable. Now operate the service.

An Arc-enabled resource is a management target; a working service is an operational outcome. The IIC Hybrid Orders application makes that distinction concrete. A customer places an order through a portal served from Azure or AWS; an Azure coordinator gives it a correlation ID; a worker in the on-premises private cloud validates it and a worker in AWS fulfills it. The order succeeds only when both answer inside the time target.

The correlation ID and timing matter because an old success or a connected machine cannot prove that the current operation works. Infinite Improbability Corp is fictional; the architecture uses real Azure, AWS and on-premises services. The companion Whole-Service Observability session models the same order with an Azure Monitor Health Model.

The remaining sections use this service context to connect monitoring, access, security, governance, cost, and action. The SCVMM-hosted workloads and the AWS resource representations remain part of the shared estate. Their individual health and configuration contribute evidence, while the user operation supplies the outcome against which that evidence is interpreted.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview
https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/overview

## Slide 21: 1 · Observe: is it working, and where do you look?

Section one of five: Observe. The question: is it working, and where do you look? This section covers Azure Monitor (where the data comes from, where it lands and how it is used), why healthy-looking servers do not prove a working service, how machine health rolls up into service health, where to ask each kind of question, and a demonstration that reads both.

## Slide 22: Azure Monitor: follow the data from collection to decision

Azure Monitor is the one place to look across the estate. Data comes from three kinds of source: servers, where the Azure Monitor agent sends logs and performance counters; Azure services, which emit their own metrics automatically; and the application, which reports its operations through Application Insights. The data is stored as logs (Log Analytics) and metrics, and used for dashboards and alerts, health models, and security analytics in Microsoft Sentinel. Each use requires its own configuration; collecting data does not enable it automatically.

Sources:
https://learn.microsoft.com/en-us/azure/azure-monitor/overview
https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview
https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/azure-monitor-workspace-overview
https://learn.microsoft.com/en-gb/azure/azure-monitor/metrics/data-platform-metrics
https://learn.microsoft.com/en-us/azure/azure-monitor/vm/metrics-opentelemetry-guest

## Slide 23: How a server's data gets in: agent + rule

The Azure Monitor agent collects nothing until a data collection rule (DCR) tells it what to collect and where to send it. A DCR association links the rule to a specific machine, which configures the agent on that machine. Logs and performance counters go to a Log Analytics workspace; OpenTelemetry metrics through the agent (preview) go to an Azure Monitor workspace. In the portal these appear as Data collection rules. When expected data is missing, check the DCR and its association first.

Sources:
https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview
https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview
https://learn.microsoft.com/en-gb/azure/azure-monitor/metrics/data-platform-metrics
https://learn.microsoft.com/en-us/azure/azure-monitor/vm/metrics-opentelemetry-guest

## Slide 24: Green servers, broken service

A connected Arc resource, fresh monitoring data and a working service are three separate checks. A server can report Connected while the service it hosts fails; monitoring data can stop arriving while the service keeps working. Only a check of the service itself, such as a fresh transaction completing end to end, proves that the service works. Healthy-looking servers are supporting evidence, not proof of the service outcome.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview
https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview

## Slide 25: From signals to machine health to service health

Machine health and service health are related but different. In the example, the commitment is that customers can complete an IIC order, and it has three required branches: Azure coordination, on-premises validation and AWS fulfillment. Inventory establishes expected resources, telemetry supplies observations, and a health interpretation connects those observations to each branch and then to the order.

A heartbeat or CPU value is useful supporting evidence, but neither alone establishes that the application request succeeds. Missing or stale observations create uncertainty that should be visible rather than silently treated as healthy.

The historical SCOM connection is the practice of modeling services, components, and dependencies to understand impact. Three SCOM-era habits should not carry forward: alert fatigue (many device alerts, few that name the affected service), duplicated collection (the same signal gathered twice, paid for twice) and blind spots (missing data displayed as healthy). Azure Monitor Health Models is introduced here at that operational level, with applicable preview boundaries. The separate observability session covers model construction and deeper configuration. The practical takeaway is to ask what a displayed state means, which evidence supports it, how fresh that evidence is, and which user operation could be affected.

Freshness and aggregation require configuration. A missing component does not universally force the same parent state; operators must inspect the model's actual roll-up behavior.

Sources:
https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/overview
https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/rollup

## Slide 26: Two places to ask questions

Resource inventory and monitoring history answer different questions. Azure Resource Graph can identify resources, placement, tags, extensions, and exposed configuration or status properties. Its query language uses a supported subset of KQL. Log Analytics also uses KQL, but queries telemetry records in its own tables.

Historical guest activity and application behavior require the appropriate monitoring data. Examples include event records, Syslog, request failures, dependency timing, and fresh machine signals. Prometheus metrics use their metric query path, while Azure platform metrics use the platform-metrics experience.

A practical investigation first identifies the expected resources and then checks their available telemetry within a defined time window. The comparison exposes missing coverage as well as observed faults. Similar query syntax does not mean Resource Graph contains the same evidence as Log Analytics. Every result should be interpreted with its source, resource scope, and time context.

Sources:
https://learn.microsoft.com/en-us/azure/governance/resource-graph/overview
https://learn.microsoft.com/en-us/azure/governance/resource-graph/concepts/query-language
https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview

## Slide 27: DEMO: query the estate, then read machine and service health

The demonstration combines resource inventory with monitoring evidence. Resource Graph establishes which Azure and Arc representations are in scope and how they are configured. Monitoring queries then establish what those resources reported during a defined time range.

A useful health view identifies the underlying store, query, resource, and latest evidence time. It connects machine observations to component condition and then to the outcome of an IIC order. A color alone is insufficient without that context, particularly when a panel contains stale data or a model has missing signals.

The operating handoff includes more than an alert name. It should state likely impact, the evidence supporting that interpretation, the responsible owner, the next permitted action, and the condition that will prove recovery. A newly placed order is stronger evidence than an older success. The next section explains the authorization boundaries around those actions.

Sources:
https://learn.microsoft.com/en-us/azure/governance/resource-graph/overview
https://learn.microsoft.com/en-us/azure/azure-monitor/overview
https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/overview
https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/rollup

## Slide 28: 2 · Secure: who is allowed to change it, and how is it protected?

Section two of five: Secure. The question: who is allowed to change it, and how is it protected? This section covers access (the separate doors into a hybrid server and who holds which key), protection with Microsoft Defender for Cloud, and detection with Microsoft Sentinel.

## Slide 29: Security starts with who can access which resource

Access to a hybrid server is not one permission. Think of four separate doors, each with its own key. Azure: an Azure role (RBAC) lets someone see or change the server as an Azure resource. Sign in: the server's own accounts, over RDP or SSH, let someone log on to Windows or Linux. Hosting: admin rights in SCVMM or in the AWS account let someone stop, move or delete the VM. Application and data: the application's own permissions decide who can use it or read its data.

A key to one door does not open the others. An Azure administrator cannot log on to the server just because of the Azure role, and a local administrator on the server has no rights in Azure. Arc adds the Azure door; it does not merge the doors.

One important exception: an Azure role that can run commands or install extensions on an Arc-enabled server can run code on it as an administrator without logging on. Treat such roles as administrative access to the server.

Sources:
https://learn.microsoft.com/en-us/azure/role-based-access-control/overview
https://learn.microsoft.com/en-us/azure/azure-arc/servers/security-identity-authorization
https://learn.microsoft.com/en-us/azure/azure-arc/servers/security-extensions

## Slide 30: Who holds which key: three rules for any estate

Least privilege can be applied with three rules. People: read-only by default, with administrative rights activated through Privileged Identity Management for a limited time after multifactor authentication. Machines and applications: each has its own identity (for example an Arc machine managed identity), only the permissions it needs, and no stored secrets. Tools that make changes: each can change one thing in one scope, and every change is recorded in the Activity Log.

In the IIC Hybrid Orders application, the operator is read-only by default, each worker can only receive from its own Service Bus queue and send results, and the Policy remediation identity can change tags in one resource group. A practical first step is to list every identity that can change a server and check it against these rules.

Sources:
https://learn.microsoft.com/en-us/azure/role-based-access-control/overview
https://learn.microsoft.com/en-us/azure/azure-arc/servers/security-identity-authorization
https://learn.microsoft.com/en-us/azure/azure-arc/servers/security-extensions
https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure

## Slide 31: DEMO: prove access to an Arc resource with Azure RBAC

This demonstration tests Azure resource authorization using the same Arc resource and two approved permission contexts. The reader context should allow observation while denying the selected management operation. The management context should permit that operation within its intended scope.

The useful evidence is the effective identity, role, target resource, denied or allowed operation, resulting resource state, and audit record. A role assignment screenshot alone is weaker than observing the expected behavior. Permission propagation can affect timing and should be distinguished from the final effective state.

The action is reversible and limited to CAS26-owned resources and temporary assignments. It does not demonstrate unrestricted guest access. If a guest sign-in is included, that requires a separate authorization explanation and verification. The example shows how least-privilege delegation can be tested rather than merely asserted.

Some Azure management permissions, including powerful extension or Run Command actions, can enable privileged execution inside the guest. They must be treated as sensitive authority even without interactive sign-in rights.

Sources:
https://learn.microsoft.com/en-us/azure/role-based-access-control/overview
https://learn.microsoft.com/en-us/azure/azure-arc/servers/security-identity-authorization
https://learn.microsoft.com/en-us/azure/azure-arc/servers/security-extensions

## Slide 32: Defender for Cloud

Microsoft Defender for Cloud is the security dashboard in Azure. For an Arc-enabled server, turning on the Defender for Servers plan installs Microsoft Defender for Endpoint, the sensor on the machine. Results come back to Defender for Cloud in two kinds: posture (what is weak: security recommendations and vulnerability findings) and protection (what is under attack: security alerts). An owner either fixes the weakness or responds to the alert. Without the plan and the sensor, no vulnerability findings or alerts come from this path; free foundational CSPM recommendations still appear.

Sources:
https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-cloud-introduction
https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-servers-overview
https://learn.microsoft.com/azure/defender-for-cloud/concept-cloud-security-posture-management

## Slide 33: DEMO: inspect a Defender for Cloud finding for an Arc-enabled server

The Defender demonstration follows a finding back to its resource and forward to a remediation decision. Coverage and evidence recency are checked first. The finding must belong to the intended Arc workload rather than merely a similarly named resource.

Interpretation depends on the finding type. A recommendation describes posture work; a vulnerability observation supplies assessment evidence; an alert indicates a protection signal requiring investigation. The appropriate action and verification differ accordingly.

The operating result is a clear owner, a justified response, and a definition of successful remediation. Closing or dismissing a finding is not equivalent to correcting the underlying condition. This resource-level reasoning prepares the audience for Sentinel's broader incident and correlation workflow.

Sources:
https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-cloud-introduction
https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-servers-overview

## Slide 34: Microsoft Sentinel

Microsoft Sentinel runs on a Log Analytics workspace. Server security events reach it through the Azure Monitor agent and a data collection rule; cloud services such as Microsoft Entra ID, Azure activity, Microsoft 365 and other SaaS applications reach it through data connectors. Scheduled analytics rules query that data and, when configured to, create incidents with entities and evidence for an owner to investigate and respond to. Without the data and the rule, no incident is created. Sentinel does not replace Defender for Cloud posture management or Azure RBAC.

Sources:
https://learn.microsoft.com/en-us/azure/sentinel/overview
https://learn.microsoft.com/azure/sentinel/microsoft-sentinel-defender-portal

## Slide 35: DEMO: investigate a Microsoft Sentinel incident

The Sentinel demonstration uses a labelled training incident to explain investigation. Incidents are investigated in the Microsoft Defender portal; Sentinel's Azure-portal experience retires after 31 March 2027. The analyst checks the environment and time range, reads the triggering evidence, identifies the involved entities, and follows the activity sequence before choosing a response.

A training incident demonstrates the workflow; it is not evidence of a real compromise. Similarly, an investigation hypothesis should be distinguished from the records that support or contradict it. Resource and account identifiers help connect the incident to the correct workload.

The intended result is an assigned owner, a documented response or escalation decision, and a clear closure condition. Automated response requires its own authorized identity and scope. Reset activities are limited to the training artifact. The next governance section explains how landing-zone placement and Policy establish the repeatable operating boundaries within which these decisions occur.

Sources:
https://learn.microsoft.com/en-us/azure/sentinel/overview
https://learn.microsoft.com/en-us/azure/sentinel/investigate-cases
https://learn.microsoft.com/azure/sentinel/microsoft-sentinel-defender-portal

## Slide 36: 3 · Govern: which team owns it, and does it stay the way we agreed?

Section three of five: Govern. The question: which team owns it, and does it stay the way we agreed? This section covers ownership through landing zones, rules through Azure Policy, regulatory compliance against a standard, keeping every estate patched with one process (including Extended Security Updates), and keeping the EKS cluster as designed with Flux.

## Slide 37: A landing zone is the operating foundation for workloads at scale

Microsoft defines an Azure landing zone as a proven and flexible architecture for governing, securing, and scaling a multi-subscription Azure environment. It has two parts. The platform landing zone is the centralized foundation: a management group hierarchy and shared services such as connectivity, identity, security monitoring and management; most organizations have one per Microsoft Entra tenant. Application landing zones host workloads: each workload gets one, containing all of its environments (for example development, test and production), each of one or more subscriptions. Azure Policy assigned on management groups is inherited by every subscription below. Landing zones can be deployed with Microsoft accelerators or built custom.

The design is organized into eight design areas: billing and tenant, identity and access, resource organization, network topology and connectivity, security, management, governance, and platform automation and DevOps.

Sources:
https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/

## Slide 38: Azure Arc landing zone

The Azure Arc landing zone accelerator for hybrid and multicloud is Microsoft guidance for operating Arc-enabled resources within the Azure landing zone. Arc resources are placed in application landing zone subscriptions and resource groups, where they inherit Azure Policy and access; the multicloud connector creates its own resource group for AWS resources. The Arc-enabled servers guidance covers identity, network, resource organization, governance and security, monitoring, cost and automation.

For Arc, the network design area is about how the Connected Machine agent reaches Azure: directly over HTTPS (TCP 443), through a proxy or firewall (Azure Arc gateway reduces the required endpoints to about eight), or privately through Azure Private Link over ExpressRoute or VPN, which requires a private endpoint in an Azure virtual network. The accelerator does not move workloads.

Sources:
https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/
https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-servers/eslz-arc-servers-connectivity

## Slide 39: Azure Policy

Azure Policy evaluates Azure resources against rules. A policy is assigned at a management group, subscription or resource group scope and is inherited by everything below it, including Azure Arc-enabled servers on-premises and in other clouds. Azure Policy reports compliance and, depending on the effect, can deny non-compliant requests or remediate resources.

Compared with Group Policy: both assign rules at a scope that are inherited, but Group Policy configures settings inside Windows on domain-joined machines, while Azure Policy governs properties of the Azure resource itself, such as tags, location, size or enabled features. Azure Machine Configuration (formerly guest configuration) audits and configures settings inside the operating system of Windows and Linux machines, on Azure VMs and Arc-enabled servers, and is assigned through Azure Policy.

Examples: require a tag (Modify adds it if missing), allowed locations (Deny blocks resources in other regions), deploy the Azure Monitor agent if missing (AuditIfNotExists or DeployIfNotExists), and machine configuration baselines such as password or TLS settings.

Sources:
https://learn.microsoft.com/en-us/azure/governance/policy/overview
https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview/01-overview-concepts

## Slide 40: How Azure Policy works

Azure Policy separates policy intent, assignment, evaluation, and enforcement or remediation. Definitions contain conditions and effects; initiatives group definitions; assignments apply them with parameters at a chosen scope. Exclusions and exemptions affect the applicable result and should remain visible in an assessment.

Effects differ. Audit reports, Deny can block supported noncompliant requests, and applicable Modify or DeployIfNotExists policies can change or deploy supported resource state. Existing resources may require a remediation task. The associated managed identity needs appropriate permissions for that work.

An assignment is therefore not proof of compliance. Operators should inspect the evaluated resource, reason, effect, identity, and observation time. Resource-level requirements and guest-configuration requirements also have different prerequisites. The demonstration verifies the actual resource state alongside a fresh Policy result so that a task status is not mistaken for the intended outcome.

Enforcement mode matters as much as the effect. In Default mode the effect applies on every matching create or update; existing resources with missing tags are corrected only by a remediation task. DoNotEnforce keeps compliance evaluation and manual remediation tasks but suppresses on-write enforcement; it is the recommended first stage for Modify and DeployIfNotExists rollouts.

Sources:
https://learn.microsoft.com/en-us/azure/governance/policy/overview
https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources
https://learn.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure#enforcement-mode

## Slide 41: Compliance

Regulatory compliance for Azure and hybrid resources does not require Microsoft Purview. Azure Policy provides built-in regulatory compliance initiatives that apply to Azure resources and Azure Arc-enabled servers, including in-guest settings through machine configuration. Microsoft Defender for Cloud assesses Azure subscriptions, Arc-enabled servers, AWS accounts and GCP projects against assigned standards in its Regulatory compliance dashboard. The Microsoft cloud security benchmark is included at no cost; assigning other standards requires a paid Defender for Cloud plan other than Defender for Servers Plan 1 or Defender for APIs Plan 1.

Microsoft Purview Compliance Manager is optional and organization-wide: it receives Defender for Cloud results automatically, combines them with Microsoft 365, and provides improvement actions and auditor reporting. It is available with Microsoft 365 and Office 365 licences; the Microsoft Data Protection Baseline is included, E5/A5/G5 customers can use three premium regulatory templates, and other premium templates are purchased as add-ons.

Standards available include NIST SP 800-53, NIST CSF 2.0, CIS, PCI DSS 4.0, ISO 27001, SOC 2, HITRUST, NIS2 and GDPR. A compliance score is evidence for auditors, not a certification. From October 27, 2026, Foundational CSPM is opt-in for new Azure subscriptions.

Sources:
https://learn.microsoft.com/en-us/azure/defender-for-cloud/regulatory-compliance-dashboard
https://learn.microsoft.com/en-us/azure/defender-for-cloud/assign-regulatory-compliance-standards
https://learn.microsoft.com/en-us/purview/compliance-manager-regulations

## Slide 42: DEMO: evaluate and remediate Arc machines with Azure Policy — on-premises, then AWS

The later AWS demonstrations reuse the resources introduced during connector onboarding. They answer a new question: what useful management result is available after connection? The source instance ID or cluster ARN remains linked to the corresponding Azure resource ID.

This demonstration runs the full Policy compliance cycle twice with one procedure: identify the exact Arc resource and its applicable assignment, read the definition and its defaults, check the remediation identity's permissions, inspect the NonCompliant reason, create one resource-scoped remediation task, and verify both the changed resource and a fresh Policy assessment.

Pass 1 targets an on-premises guest under the operations resource-group assignment. Pass 2 targets an AWS EC2 server's Azure Arc representation under a second assignment scoped to the connector-created AWS resource group with an explicit machine allowlist. The second assignment exists because scope and tag filters that fit on-premises machines do not reach connector-created resources.

Both assignments use enforcement mode DoNotEnforce. Compliance is still evaluated and remediation tasks still work, but the Modify effect does not fire on every resource update; in Default mode the tag would be corrected on a resource write or the next periodic evaluation (typically about every 24 hours). The Owner tag on the AWS Arc representation is Azure metadata; the native EC2 tag and AWS lifecycle are unchanged.

Evidence to keep: exact resource IDs, assignment and definition IDs, acting identity, before/after tag values, remediation task result, and the timestamp of the fresh Policy evaluation. A task result alone is not compliance, and a tag alone is not accepted ownership.

Sources:
https://learn.microsoft.com/en-us/azure/governance/policy/overview
https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources
https://learn.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure#enforcement-mode
https://learn.microsoft.com/en-us/azure/azure-arc/multicloud-connector/onboard-multicloud-vms-arc

## Slide 43: What the Policy demo proved

The Policy demonstration applied one policy definition through two scoped assignments to two machines, one on-premises and one in AWS. Each noncompliant resource was identified, a bounded remediation task ran, and fresh compliance evidence verified the result. The same discipline applies to every operational change: identity, scope, bounded action, fresh outcome.

Sources:
https://learn.microsoft.com/en-us/azure/governance/policy/overview
https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources
https://learn.microsoft.com/en-us/azure/azure-arc/system-center-virtual-machine-manager/overview

## Slide 44: Three estates, one patch process: why Azure Update Manager

Hybrid estates usually patch each environment with its own tool: Azure virtual machines in Azure, on-premises servers with WSUS or Configuration Manager, and AWS instances with Systems Manager Patch Manager. That means separate schedules, reports and permission models, and no single place to answer whether everything is patched.

Azure Update Manager assesses, schedules and reports updates for Azure virtual machines and for Arc-enabled servers anywhere, Windows and Linux, from one view. Arc supplies the Azure identity that lets one service reach on-premises and other-cloud servers. Platform services such as Azure Functions are patched by Microsoft, and clustered Hyper-V hosts normally keep cluster-aware updating for the actual patching.

For a service that depends on several environments, patching is a service decision: plan windows so the service keeps working, and prove each window with a real transaction afterwards.

Sources:
https://learn.microsoft.com/en-us/azure/update-manager/overview
https://learn.microsoft.com/en-us/azure/update-manager/support-matrix

## Slide 45: How Update Manager patches every estate: assess, schedule, ring, prove

Azure Update Manager works in five stages. Periodic assessment checks machines for missing updates roughly every 24 hours and can be enabled at scale with a built-in Azure Policy. A maintenance configuration defines the window, classifications and reboot behaviour. A dynamic scope attaches machines to that window by filters such as resource group, location, operating system and tags, so correctly tagged new machines join automatically. Rolling out in rings, from canary machines to production, limits the blast radius, and pre and post events can run automation around each window.

Proof comes from fresh compliance data, for example in Azure Resource Graph, and from a working service after the window; a completed patch run alone does not show recovery. Clustered hosts can be assessed and reported in the same view while cluster-aware updating performs their patching.

Sources:
https://learn.microsoft.com/en-us/azure/update-manager/scheduled-patching
https://learn.microsoft.com/en-us/azure/update-manager/dynamic-scope-overview
https://learn.microsoft.com/en-us/azure/update-manager/periodic-assessment-at-scale
https://learn.microsoft.com/en-us/azure/update-manager/pre-post-scripts-overview

## Slide 46: End of support: Extended Security Updates through Arc

Extended Security Updates (ESUs) can be delivered to end-of-support Windows Server machines through Azure Arc, billed monthly through Azure and patched with the same tools, including Azure Update Manager. They are licensed by core, with a minimum of eight virtual cores per VM or sixteen physical cores per server, and require Software Assurance or an equivalent subscription.

For Windows Server 2012 and 2012 R2, ESUs end on October 13, 2026. As an illustration at US list price ($0.00648 per core-hour), an eight-core Standard VM costs about $38 a month, and late enrolment is back-billed to the start of the ESU term. After that date no further security updates are available, so these servers must be upgraded or migrated.

For Windows Server 2016, extended support ends on January 12, 2027. ESUs through Arc can be configured now and are billed from January 13, 2027; the same VM at $0.007132 per core-hour costs about $42 a month for up to three years. ESU-enrolled servers receive Update Manager at no extra charge; otherwise it costs $5 per Arc server per month. Prices are illustrative and should be checked against your agreement.

Sources:
https://learn.microsoft.com/en-us/windows-server/get-started/extended-security-updates-overview
https://learn.microsoft.com/en-us/lifecycle/faq/extended-security-updates
https://learn.microsoft.com/en-us/azure/azure-arc/servers/license-extended-security-updates
https://learn.microsoft.com/en-us/azure/update-manager/update-manager-faq
https://prices.azure.com/api/retail/prices

## Slide 47: DEMO: Update Manager across every estate: assess, schedule, patch, prove

This demonstration shows one update process working across two hosting locations. A single Azure Resource Graph query lists pending updates for on-premises and AWS Arc-enabled servers with their assessment times. A maintenance configuration's dynamic scope selects machines by tags from both environments, and changing a machine's tag moves it between schedules without editing any list.

A one-time update limited to security updates is then applied to two canary machines, one on-premises and one in AWS, followed by the run result for each and a fresh assessment. The run result shows that patching ran; fresh compliance and a working service show the outcome. Production workers are patched in their own planned windows, never ad hoc during a demonstration.

Sources:
https://learn.microsoft.com/en-us/azure/update-manager/query-logs
https://learn.microsoft.com/en-us/azure/update-manager/deploy-updates
https://learn.microsoft.com/en-us/azure/update-manager/dynamic-scope-overview

## Slide 48: Keep the Kubernetes cluster the way Git says (GitOps with Flux)

After Arc-enabled Kubernetes onboarding, an EKS cluster can use supported Azure management capabilities such as GitOps with Flux. The cluster remains EKS, with its AWS lifecycle and platform responsibilities intact.

Flux applies declared configuration from a source repository and reconciles the target cluster toward that state. The example uses a bounded namespaced object so that the source and resulting configuration can be inspected clearly. This management action is different from discovering the cluster or creating its Arc connection.

Prerequisites include the connected cluster, required agents and extension, source access, Azure authorization, and the intended Kubernetes scope. Verification should connect the EKS ARN, Azure cluster ID, source revision, Flux status, and actual Kubernetes object. A successful Azure configuration submission alone is weaker evidence than observing reconciliation in the cluster.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/multicloud-connector/onboard-elastic-kubernetes-service-clusters-arc
https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/conceptual-gitops-flux2

## Slide 49: DEMO: manage the already-onboarded EKS cluster with Flux

The Flux demonstration proves a configuration result on the already-connected EKS cluster. It maps the source cluster to its Azure representation, inspects the GitOps configuration and source revision, and checks the resulting CAS26 object inside the intended namespace.

Reconciliation is asynchronous. A submitted configuration and a completed reconciliation are different states. The strongest evidence combines the relevant Azure status with the actual Kubernetes object and its expected content. A similarly named existing object alone does not prove that the demonstrated source revision was applied.

The example is bounded to CAS26-owned configuration. Reset follows its defined cleanup behavior rather than assuming that deleting a management configuration reverses every cluster change. This completes the progression from discovery through onboarding to management proof, while AWS continues to own the EKS platform lifecycle.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/conceptual-gitops-flux2
https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/tutorial-use-gitops-flux2

## Slide 50: 4 · Cost: what does it cost, and how do we keep it in check?

Section four of five: Cost. The question: what does it cost, and how do we keep it in check? This section covers what Azure Arc costs, how to see and control hybrid cost, log transformations that filter monitoring data before it is stored, and the full cost of a hybrid service.

## Slide 51: What Arc costs: free, paid, and free if you already own it

Azure Arc control plane capabilities are free: resource organization with management groups and tags, Azure Resource Graph, Azure RBAC, and templates and extensions, as well as inventory and VM operations for Arc-enabled SCVMM and VMware vSphere. Azure services used with Arc are billed at their own rates: for example Azure Monitor data ingestion and retention, Microsoft Defender for Servers, Microsoft Sentinel, Azure Update Manager (per Arc-enabled server per month, prorated daily), machine configuration, change tracking and Extended Security Updates.

Windows Server Management enabled by Azure Arc provides Azure Update Manager, Change Tracking and Inventory, machine configuration and Windows Admin Center at no extra cost for servers with active Software Assurance or subscription licences, after attestation, or enrolled in Windows Server pay-as-you-go. Update Manager is also free for servers enrolled in Extended Security Updates through Arc and for subscriptions with Defender for Servers Plan 2.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/overview#pricing
https://learn.microsoft.com/en-us/azure/azure-arc/servers/windows-server-management-overview
https://learn.microsoft.com/en-us/azure/update-manager/update-manager-faq#pricing

## Slide 52: See it and control it: the cost levers

Managing cost in a hybrid operating model has two parts. Visibility: Microsoft Cost Management reports Microsoft cloud spend; consistent tags, enforced with Azure Policy, let costs roll up by service and owner; budgets and anomaly alerts give early warning; and costs from AWS and on-premises tools can be joined using the same tags, for example with FOCUS-format exports. Control: five levers are telemetry (collect only what answers an operating question), licensing (Software Assurance benefits, Azure Hybrid Benefit, pay-as-you-go), commitments (reservations and savings plans for Azure resources), right-sizing and clean-up (Azure Advisor), and guardrails (Policy that requires tags and restricts expensive choices).

Sources:
https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/overview-cost-management

## Slide 53: Log transformations

Transformations in Azure Monitor are KQL queries in a data collection rule (DCR) that run on each incoming record before it is stored in a Log Analytics workspace. Filtering rows (for example with where) and removing unneeded columns (with project-away) reduces billable ingestion; transformations can also mask or remove sensitive data. Multi-stage transformations (preview) can run on the Azure Monitor agent, before data leaves the machine.

If a transformation drops more than 50% of the incoming data sent to Analytics or Basic tables, the dropped data beyond 50% incurs a data processing charge (for example, 20 GB in with 12 GB dropped is billed as 8 GB ingestion and 2 GB processing). This charge does not apply to Analytics tables in a workspace with Microsoft Sentinel enabled.

Table plans are a related cost control: Analytics (full features), Basic (reduced ingestion price, query charges, for troubleshooting) and Auxiliary (lowest ingestion price, for low-touch audit data).

Sources:
https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-transformations
https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-transformations-samples
https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs#table-plans

## Slide 54: The full cost of a hybrid service

Total hybrid operating cost includes more than Azure service charges. A useful model separates capability and entitlement, metered Azure usage and allocation, source-environment infrastructure or transfer, and people and tooling effort.

A workload hosted on SCVMM or AWS continues consuming resources there even when Azure manages its representation. Monitoring, protection, and analytics can add further service costs. Shared platforms may require an explicit allocation method because resource tags alone do not divide every charge accurately.

Current entitlements and prices must be checked against the applicable plan and agreement. The session supplies a way to explain cost, not a universal quotation or an observed invoice. The resulting review should connect usage to a workload owner and a decision: retain, tune, replace, or retire a capability based on its operating value.

Sources:
https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs
https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/understand-work-scopes

## Slide 55: 5 · Adopt the patterns: did the fix work, and what do we keep doing?

Section five of five: Adopt the patterns. The question: did the fix work, and what do we keep doing? This section covers letting systems make fixes safely, the playbook, what to unlearn, and a first thirty days.

## Slide 56: Letting the system fix things: how much, and how you prove it

Here the topic is fixes that systems make on your behalf, such as Azure Policy remediation, scheduled patching with Azure Update Manager, and Flux reconciliation, rather than CI/CD pipelines. There are three levels: report only, where a person reviews and nothing changes on its own; fix with approval, where the system proposes a change and a person approves it; and continuous correction, where the system corrects drift on its own. Every level should end with verification of the resource and the service outcome, with a defined response when the check fails. Before allowing a system to make fixes, define the owner, permissions, blast radius, stop conditions and the evidence that proves the fix worked.

Sources:
https://learn.microsoft.com/en-us/azure/governance/policy/overview
https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources
https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/conceptual-gitops-flux2

## Slide 57: The playbook: what to adopt

The playbook turns each section into a practice with an owner, a next action and evidence. Observe: one place to look and one alert on the service outcome. Secure: apply least-privilege rules to people, machines and tools that make changes, and confirm Defender coverage. Govern: place resources in the designed landing zone, assign a compliance standard with Azure Policy, and use one patch process. Cost: enforce tags, attest Software Assurance benefits and set budgets per service. Adopt: allow systems to make fixes only where a verification step proves the outcome.

Sources:
https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-servers/eslz-management-and-monitoring-arc-server
https://learn.microsoft.com/en-us/azure/governance/policy/overview
https://learn.microsoft.com/en-us/azure/update-manager/overview
https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs

## Slide 58: And what to unlearn

Five assumptions are worth retiring. A heartbeat does not prove the service works. A connected resource is not necessarily secured. A policy assignment is not the same as compliance. A missing cost line does not mean a service is free. A completed task does not prove recovery. Each has a check: a fresh transaction, access and coverage review, evaluation results, the meter and licence benefit, and outcome verification.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview
https://learn.microsoft.com/en-us/azure/governance/policy/how-to/get-compliance-data
https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/overview
https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs

## Slide 59: Your first thirty days

A practical first month: in week one, inventory resources and name owners; in week two, review access against least-privilege rules, place resources in the landing zone and assign a compliance standard; in week three, build one service view and one alert on the service outcome; in week four, enforce tags and budgets and introduce one system-made fix that is verified by a fresh transaction. Start with one service and repeat the pattern.

Sources:
https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-servers/landing-zone-accelerator
https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-servers/eslz-identity-and-access-management

## Slide 60: Let’s keep the conversation going

Contact Kristopher Turner at kris@hybridsolutions.cloud for follow-up. The accompanying repository and attendee material provide the slide explanations, technical references, and demonstration context.

Examples must be adapted to the reader's own identities, permissions, supported platforms, and resource scopes. Demonstration configuration is not a universal production baseline. Use the material to preserve the operating questions and verification approach while designing the appropriate implementation for your environment.

## Slide 61: Whole-Service Observability

Whole-Service Observability complements this session with implementation depth in telemetry collection, correlation, dependencies, Health Models, investigation, and recovery verification. Hybrid Operations establishes the broader management, security, governance, cost, and operating context.

The sessions share the environment and workload identities, but each has its own teaching purpose. Health-model authoring and detailed signal configuration belong in the observability session. The overview here is sufficient to distinguish machine evidence from the service outcome and understand the management decisions built around it.

Both sessions use the same example application, IIC Hybrid Orders, running in Azure, AWS and an on-premises private cloud. This session operates it; the companion session builds its Health Model, introduces a controlled fault in one cloud and proves recovery with a new order.

## Slide 62: Other sessions worth attending

The recommended conference sessions extend the themes of hybrid management, security, governance, and observability. Consult the current event programme for final titles, speakers, times, and locations. Recommendations are intended to help select a relevant next topic rather than imply that another session is required to understand this one.

## Slide 63: Questions?

Use the closing discussion to apply the operating model to a concrete workload. Useful questions identify the resource, owner, evidence source, permission boundary, intended action, and condition that would prove success.

Environment-specific answers can depend on current configuration, supported versions, service availability, licensing, and scope. The session provides a method for asking and verifying those questions rather than assuming every hybrid estate has the same capabilities or operating constraints.

## Slide 64: Thank you — feedback & resources

This closing slide provides the feedback link for Hybrid Operations in 2026 and points to the public CAS26 repository. Use the QR code to share feedback while the slide is displayed; it tells the presenter which parts of the operating model were clear and which need more work.

The repository contains the storyboard, deck materials, demo runbooks, lab documentation, handouts and references, including the design of the IIC Hybrid Orders example application. Each demo runbook states its prerequisites, expected evidence and reset steps, so it can be adapted to your own environment. Private credentials and environment-specific configuration are not included.

