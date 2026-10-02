# Hybrid Operations — presenter notes

## Slide 1: Hybrid Operations in 2026

KEY POINTS

• Operating question: how do we run one hybrid estate consistently across places and teams?
• Follow the decisions: connect · observe · secure · govern · pay.
• Workloads stay in Azure · the datacenter · AWS; Azure adds a management surface.
• IIC Hybrid Orders: Infinite Improbability Corp’s fictional portal links the demonstrations.
• Companion observability session covers collection · correlation · Health Models in depth.
• → Next: acknowledge the sponsors.

TALKING POINTS

Open with the operating question: how do we run one hybrid estate consistently when the infrastructure and the teams are in different places? Establish that this session follows real operating decisions, from connecting resources through observing, securing, governing, and paying for them. The workloads remain in their original environments. Azure becomes an additional management surface, not the location to which every workload must move.

Preview the teaching estate through one application: IIC Hybrid Orders, the order portal of the entirely fictional Infinite Improbability Corp. It runs in Azure, in our on-premises private cloud and in AWS, and its servers and cluster return in almost every demonstration so the audience can connect the results. Explain that the companion observability session goes deeper into collection, correlation, and Health Models; this session supplies the wider operating context. Transition to the sponsor acknowledgement.

PURPOSE

Open with the operating problem, not a product. By the end of this slide the audience should know the question the session answers: how to run one estate consistently when the workloads stay in Azure, in the datacenter and in AWS. Every later section is one step toward that answer.

## Slide 2: Thank you to our sponsors

KEY POINTS

• Thank the event sponsors using approved wording and artwork.
• Say: sponsor acknowledgement, not a technology endorsement or demo-vendor list.
• Keep the acknowledgement under thirty seconds.
• → Next: operator background.

TALKING POINTS

Thank the event sponsors briefly using the approved event wording and artwork. This slide is an acknowledgement, not a technology endorsement or a list of vendors assumed to be present in the demonstration environment. Keep the introduction moving and transition to your operator background.

PURPOSE

Thank the sponsors who make the event possible and move on. This slide carries no technical message; keep it under thirty seconds.

## Slide 3: About Kristopher Turner

KEY POINTS

• Operational work begins after a resource is deployed or connected.
• Introduce approved credentials; avoid reading every badge or link.
• Follow-up: kris@hybridsolutions.cloud; repository and attendee notes hold supporting material.
• → Next: hybrid persists because workload · locality · ownership · investment needs differ.

TALKING POINTS

Introduce yourself using the approved photo, credentials, and current contact details. Connect your background to the subject in one concrete sentence: the session is about the operational work that begins after a resource has been deployed or connected. Avoid reading every badge or link aloud. Point attendees to kris@hybridsolutions.cloud for follow-up and explain that the repository and attendee notes contain the supporting material.

Transition by observing that hybrid environments have persisted because organizations have different workload, locality, ownership, and investment needs. The operational model must accommodate that reality.

PURPOSE

Establish in one sentence why you are credible on this topic and give attendees a way to reach you. The room should leave this slide knowing you run these environments, not only present them.

## Slide 4: Hybrid stayed. The operating model has to catch up.

KEY POINTS

• Hybrid stayed: Azure · datacenter · other cloud · edge sites · older systems.
• Which team owns it? Cloud team · infrastructure team · another cloud team · site staff · whoever still knows it.
• Is it working, and where do you look? Azure Monitor · SCOM/VMM/vCenter · CloudWatch · local tools · old agents or nothing.
• Who is allowed to change it? Azure RBAC · AD groups/hypervisor roles · AWS IAM · local admins · legacy model.
• What does it cost? Azure invoice · hardware/licences/power · AWS invoice · site budget · extended support.
• One service spans columns: four questions, five answers each.
• Ask the room: which of these four rows costs you the most time?
• → Next: five outcomes, with Azure Arc as the common foundation.

TALKING POINTS

Start with the columns. Hybrid did not go away: most estates have Azure, a datacenter, at least one other cloud, some remote or edge sites, and a few older systems nobody wants to touch. None of that is moving soon.

Now read each row across; each one is a plain question. Start with ownership, because that is where most of the time goes. Which team owns it? A cloud team, an infrastructure team, another cloud team, site staff, and whoever still remembers the old systems. Is it working, and where do you look? Azure Monitor, SCOM or the VMM and vCenter consoles, CloudWatch, local tools over weak links, and old agents or nothing at all. Who is allowed to change it? Azure RBAC, AD groups and hypervisor roles, AWS IAM, local admin accounts, a legacy admin model. What does it cost? An Azure invoice, hardware, licences and power, an AWS invoice, a site budget, extended support.

Then point out that one service can touch several of these columns at once. When it fails, every question has five different answers, and the time goes into finding out which team, which console and which account.

Close on the promise: every row comes back as a section of this session, and the last section adds whether the fix actually worked. Ask the room which row costs them the most time today. Transition to the five outcomes this session will teach.

PURPOSE

Name the real problem before offering any technology: every basic operating question has five different answers across the estate.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/overview

## Slide 5: What we’ll cover and demonstrate

KEY POINTS

• Five operating outcomes, not a product catalogue.
• Connect through Azure Arc: server · virtualization · Kubernetes onboarding differ.
• Monitor: turn resource facts into machine and service evidence.
• Secure access: who can act · Defender for Cloud findings · Sentinel investigation.
• Govern: landing zones · Policy · one patch process · Extended Security Updates.
• Examine costs and dependable automation practices.
• Demos: server onboarding; Arc-enabled SCVMM architecture; AWS discovery, then EC2/EKS proof.
• → Next: define Arc; detailed monitoring implementation stays in the companion session.

TALKING POINTS

Walk the agenda as a chain of outcomes rather than a product catalogue. First, connect the estate through Azure Arc and distinguish server, virtualization, and Kubernetes onboarding. Second, explain how monitoring changes resource facts into useful machine and service evidence. Third, address access and security: who can act, what Defender for Cloud identifies, and how Sentinel supports investigation. Fourth, govern and manage them: place those resources within a landing-zone and Policy design, and keep every server in all three estates patched through one update process, including end-of-support servers on Extended Security Updates. Finally, examine costs and the operating practices that make automation dependable.

Set expectations for the demonstrations. Individual server onboarding is a demonstration; the SCVMM platform is already Arc-enabled, so we walk its architecture rather than onboarding it live. The SCVMM-hosted workloads recur in the Arc examples. AWS discovery and onboarding lead to later EC2 and EKS management proof. Both sessions share the same landing-zone, resource-group, monitoring, security, and Policy baseline.

Tell the audience that monitoring receives enough explanation here to understand the agents, stores, queries, and health view. Model authoring and detailed investigation belong in the complementary session. Transition to a plain definition of Arc before naming any agent or connector.

PURPOSE

Give the audience the route map. They should know the five outcomes, which ones are demonstrated live, and that deep monitoring implementation lives in the companion session. With this map they can place every later demo in the story.

## Slide 6: Azure Arc extends Azure management to resources running elsewhere.

KEY POINTS

• Azure Arc gives supported external resources Azure management identities without moving workloads.
• Trace existing resource → Azure representation → operating service.
• Datacenter server keeps serving; operators see identity · tags · applicable configuration.
• Monitoring · security · governance each need prerequisites · authorization · evidence.
• Say: Arc management traffic is not application traffic or proof of telemetry.
• SCVMM · VMware · Kubernetes follow the pattern through different integrations.
• → Next: what connecting one server involves.

TALKING POINTS

Define Azure Arc as a set of capabilities that extends Azure management to supported resources outside Azure. Trace the diagram from the existing resource to its Azure representation and then to an operating service. The representation gives the organization an Azure resource on which it can apply supported management features. It does not move the workload or replace every function of the platform on which that workload runs.

Use an on-premises server as the simplest example. A machine can continue serving its application in the datacenter while an Azure operator sees its resource identity, tags, and applicable management configuration. That resource can become a target for separately configured monitoring, security, and governance services. Each service has its own prerequisites, authorization, and evidence path.

Make the traffic distinction early. Arc management communication is not the application request path between users and the workload. Nor does the existence of an Arc resource establish that application telemetry is arriving. The same conceptual pattern appears for SCVMM, VMware, and Kubernetes, but their integration mechanisms differ. Avoid presenting one universal agent for all of them. Transition to one server and what connecting it involves.

PURPOSE

Define Azure Arc in plain terms before any agent or connector appears. The one idea to land: Arc gives a resource outside Azure an Azure identity that management services can target, without moving the workload. Every later slide builds on that representation.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/overview
https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview

## Slide 7: Connecting a server to Arc

KEY POINTS

• Connecting a server to Arc: three things to know before you do it.
• Your server → one outbound connection (HTTPS 443) → an Azure resource → proof.
• One outbound connection: no inbound ports, no VPN; the app never uses it.
• Where it lands sets its rules: the subscription and resource group decide inherited Policy and access.
• Prove it worked: azcmagent show says Connected, and the same machine appears in Azure, in the right place.
• Services you add later (Monitor, Defender, Policy, Update Manager) come in the rest of the session.
• → Next: the demo, connecting our own machines.

TALKING POINTS

Zoom from the whole estate to one server. Read the top row left to right, and each card underneath explains the box above it.

Your server keeps running where it is; you install the Connected Machine agent on it. The agent makes one outbound HTTPS connection on port 443. No inbound ports, no VPN, and the application never uses that connection.

The machine shows up as an Azure resource in the subscription and resource group you chose, and that choice matters: it decides which Policy and which access rules the server inherits from then on.

Then prove it worked, on both sides: azcmagent show on the machine says Connected, and the same machine appears in Azure in the place you intended.

The services come later: monitoring, Defender, Policy and Update Manager are each added separately, and the rest of the session covers them. Transition: now we do exactly this on our own machines.

PURPOSE

Say only the three things an operator needs before connecting a server: one outbound connection, placement decides the rules, and how to prove it worked.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview
https://learn.microsoft.com/en-us/azure/azure-arc/servers/network-requirements

## Slide 8: DEMO: connect the on-premises/edge machines to Azure Arc

KEY POINTS

• Prove an owned CAS26 machine connects to the intended Azure scope on both sides.
• Open runbook; identify selected machine, subscription, resource group, and shared landing-zone baseline.
• Say: do not display credentials or use a broad personal administrator identity.
• Check prerequisites; distinguish existing installation; install supported agent; connect with scoped, authorized identity.
• Inspect azcmagent show and Azure resource: ID · identity · placement · tags · status.
• Wait until both sides agree; command success alone does not prove connection.
• Debrief: Azure management representation and agent connection exist; monitoring · Defender · Policy come later.
• → Next: two distinct management layers in a virtualization estate.

TALKING POINTS

Before leaving the slide, state the question being proved: can we connect an owned machine to the intended Azure management scope and verify both sides of that connection? Open the runbook and identify the selected CAS26 machine without displaying credentials. Show the target subscription and resource group and explain how they relate to the shared landing-zone baseline.

Walk through the prerequisite check, supported agent installation, and scoped connection command. Explain which identity is authorized to onboard the machine and avoid substituting a broad personal administrator context merely because it is convenient. If the agent is already installed, distinguish an existing installation from the connection step being demonstrated.

After connection, inspect azcmagent show and the matching Azure resource. Compare resource ID, machine identity, placement, tags, and reported connection status. A successful command alone is not the final proof. Onboarding is asynchronous: wait until both sides agree before calling the machine connected.

Debrief by naming what now exists: the Azure management representation and agent connection. Monitoring collection, Defender coverage, and Policy are separate configuration steps, and the later demos show each of them. Transition: the software that already runs these VMs, SCVMM and vCenter.

PURPOSE

This is the first live proof: one on-premises machine becomes an Azure resource. The audience should see both sides agree, the agent on the machine and the resource in Azure, and understand that monitoring, security and Policy are separate steps that come later.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview
https://learn.microsoft.com/en-us/azure/azure-arc/servers/security-identity-authorization

## Slide 9: SCVMM and vCenter

KEY POINTS

• SCVMM and vCenter: the software that already creates and runs your VMs.
• Stack: apps + guest OS (what the agent connected) → the VM → SCVMM or vCenter → hosts and clusters.
• The agent sees one machine, from the inside.
• SCVMM or vCenter sees every VM from underneath, even VMs with no agent and VMs that are powered off.
• Arc can connect to SCVMM or vCenter once, instead of to each VM.
• From here on, "the platform" means SCVMM or vCenter.
• → Next: connecting SCVMM or vCenter to Azure Arc.

TALKING POINTS

We just connected machines from the inside, with the agent. Before the second way in, a quick word on what sits underneath those VMs.

Read the stack from the top. At the top is what the agent connected in the demo: the apps and the guest operating system. Under that is the VM itself. Under the VM is the software that creates and runs it: SCVMM for Hyper-V, or vCenter for VMware. It creates, starts, stops and moves VMs, and it knows every VM, template and network. At the bottom are the hosts and clusters; in our lab that is hvcl-ral-t1.

Now the three points. The agent sees one machine, from the inside. SCVMM or vCenter sees every VM from underneath, including VMs that have no agent and VMs that are powered off. And Arc can connect to SCVMM or vCenter once, instead of to each VM. When I say "the platform" from here on, that is what I mean. Transition: how you connect SCVMM or vCenter to Azure Arc.

PURPOSE

Introduce SCVMM and vCenter in plain words before any Arc detail, so "the platform" is defined before it is used.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/system-center-virtual-machine-manager/overview
https://learn.microsoft.com/en-us/azure/azure-arc/vmware-vsphere/overview

## Slide 10: Connect SCVMM or vCenter to Azure Arc

KEY POINTS

• One drawing for SCVMM or VMware: same pattern, different management server.
• Requests, left to right: Azure → custom location → resource bridge → SCVMM or vCenter → VMs.
• Inventory, right to left: the bridge discovers VMs, clouds, templates, networks; you enable what Azure manages.
• Enable guest management: installs the agent in a running VM, joining both doors.
• Say: VMware through vCenter; Cloud Director tenant access is not vCenter access. Our lab uses SCVMM.
• Say once: Arc-enabled SCVMM new onboarding stops Oct 2026, service retires Sept 2029.
• Management-only users → Arc-enabled servers; VM-lifecycle users → contact Microsoft. VMware not affected.
• → Next: the SCVMM-hosted workloads we follow through the demos.

TALKING POINTS

This is how you connect SCVMM or vCenter to Azure Arc. It is the same drawing for both; only the management server changes.

Start on the left with the Azure side: the SCVMM or vCenter resource, a custom location that tells Azure where to send requests, and the VMs you have enabled. Follow the top lane to the right: a request such as start, stop, create, resize or enable guest management goes through the custom location to the resource bridge, a small appliance VM on-premises that holds the only connection to Azure, and SCVMM or vCenter carries it out on the cluster. Then the bottom lane back: the bridge discovers the VMs, clouds, templates and networks, and you choose which ones Azure should manage. Enabling guest management installs the agent in a running VM, which is where the two ways in meet; the next slide compares them.

VMware works the same way through vCenter. One VMware trap: access to a VMware Cloud Director tenant is not vCenter access. Our lab uses SCVMM on the hvcl-ral-t1 cluster.

Say the SCVMM news once, here. Microsoft announced this month that Arc-enabled SCVMM is retiring: new onboarding stops in October 2026 and the service ends in September 2029. If you only use it for management services, the move is to Arc-enabled servers. If you use the VM lifecycle operations, Microsoft's guidance is to contact them. Arc-enabled VMware vSphere is not affected. Transition: the two ways into Arc, side by side.

PURPOSE

Walk the platform connection once for both SCVMM and VMware, and deliver the SCVMM retirement news once.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/system-center-virtual-machine-manager/overview
https://learn.microsoft.com/en-us/azure/azure-arc/system-center-virtual-machine-manager/quickstart-connect-system-center-virtual-machine-manager-to-arc
https://learn.microsoft.com/en-us/azure/azure-arc/resource-bridge/overview

## Slide 11: Two ways to bring a VM into Arc

KEY POINTS

• Two ways to bring a VM into Arc, now that both have been shown.
• Inside the VM: the agent, as in the demo. Gives guest services: monitor, secure, patch.
• Through SCVMM or vCenter: Arc-enabled SCVMM or Arc-enabled VMware vSphere. Gives VM operations (start, stop, create) and sees every VM.
• Use both and it is still one Azure resource per VM.
• Say: the agent on the VMM server connects that one server, not the VMs it manages.
• → Next: the same idea for AWS and GCP, through the multicloud connector.

TALKING POINTS

A quick comparison, now that you have seen both ways in.

Top row, inside the VM: the agent, which is what we did in the demo. It makes the VM an Arc-enabled server, and that gives you the guest services: monitor it, secure it, patch it.

Bottom row, through SCVMM or vCenter: what the last slide connected. Microsoft calls these Arc-enabled SCVMM and Arc-enabled VMware vSphere. A request such as start, stop or create goes from Azure through the resource bridge, and SCVMM or vCenter carries it out; the list of VMs flows back the other way. This way sees every VM, even ones without an agent.

The dashed line: use both and each VM is still one Azure resource, with both its VM operations and its guest services.

One common mistake: putting the agent on the VMM server connects that one server, not the VMs it manages. Transition: the same idea for AWS and GCP, through the multicloud connector.

PURPOSE

Compare the two ways into Arc side by side, after both have been shown, so attendees can choose between them.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/system-center-virtual-machine-manager/overview
https://learn.microsoft.com/en-us/azure/azure-arc/vmware-vsphere/overview

## Slide 12: The multicloud connector

KEY POINTS

• The multicloud connector: one Azure resource that brings AWS and GCP into Azure.
• You give it read access to your AWS account or GCP project; it costs nothing and re-scans on a schedule.
• Job 1, Inventory: your AWS and GCP resources, listed in Azure.
• Job 2, Arc onboarding for servers: EC2 and GCP VMs onboarded to Arc for you.
• Job 3, Arc onboarding for EKS (preview): EKS clusters become Arc Kubernetes clusters.
• Say: AWS is what we demo; GCP support is in preview.
• → Next: how it works, step by step.

TALKING POINTS

Before the mechanics, what is this thing? The multicloud connector is one Azure resource that you point at an AWS account or a GCP project. You give it read access in that cloud, and from then on it scans that account on a schedule. The connector itself costs nothing.

It can do three jobs for you, and you choose which. One, Inventory: it lists your AWS or GCP resources in Azure, so you can search and tag them next to your Azure resources. Two, Arc onboarding for servers: it finds your EC2 instances or GCP VMs and installs the Arc agent on them for you, so they become Arc-enabled servers like the one we connected earlier. Three, Arc onboarding for EKS, in preview: it turns your EKS clusters into Arc Kubernetes clusters.

We will demo AWS; GCP support is in preview. Transition: now how it works, step by step.

PURPOSE

Introduce the connector in plain words before its mechanics, so the next three slides and the AWS demo make sense to someone who has never heard of it.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/multicloud-connector/overview

## Slide 13: How the connector works

KEY POINTS

• How the connector works: four steps, in order.
• 1 Give Azure access: in AWS a CloudFormation template creates a role Azure can use; GCP (preview) uses a Terraform script.
• 2 The connector: an Azure resource that uses that access.
• 3 It brings things in: a read-only list (Inventory); the Arc agent on EC2 servers, through AWS Systems Manager; the Arc agents on EKS clusters (preview).
• 4 You manage them, each set up separately: servers get Policy, Monitor, Update Manager; EKS gets Flux and Policy.
• Say: AWS is what we demonstrate; GCP support is in preview.
• Say: listed in Azure is not managed.
• → Next: step 3 is where EC2 and EKS go different ways.

TALKING POINTS

Walk the four steps left to right; the numbers are the real order.

One, give Azure access. In your AWS account, a CloudFormation template creates a role that Azure is allowed to use. For GCP, which is in preview, a Terraform script does the same job. AWS is what we demonstrate today.

Two, the connector: an Azure resource that uses that access.

Three, it brings things in. First a read-only list of what is there, called Inventory. Then, if you turn it on, it onboards servers: it installs the Arc agent on EC2 instances through AWS Systems Manager, and on GCP VMs through OS Config in preview. And in preview, it installs the Arc agents on EKS clusters.

Four, you manage them, and each service is set up separately: servers get Policy, Monitor and Update Manager; EKS gets Flux and Policy.

The caption is the lesson: listed in Azure is not managed. Transition: step three is where EC2 and EKS go different ways; the next slide shows how.

PURPOSE

Walk the connector as four plain steps, from giving access to managing what it brings in, for people who have never seen it.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/multicloud-connector/overview

## Slide 14: Onboarding EC2 and EKS

KEY POINTS

• Onboarding EC2 and EKS: each becomes a different kind of Arc resource.
• EC2: the connector installs the agent through AWS Systems Manager → Arc-enabled server (Microsoft.HybridCompute/machines).
• EKS (preview): the connector installs the Arc agents → Arc-enabled Kubernetes cluster (Microsoft.Kubernetes/connectedClusters).
• Then you add services: servers get Policy, Monitor, Defender, Update Manager; clusters get Flux, Policy, supported Kubernetes services.
• Say: Arc does not turn EKS into AKS, and AWS still owns the lifecycle.
• → Next: we do this with our AWS account.

TALKING POINTS

Two columns, read top to bottom.

Left, an EC2 server. The connector installs the Connected Machine agent through AWS Systems Manager, the agent registers, and you get an Arc-enabled server; the small text is the resource type, Microsoft.HybridCompute/machines. Then you add services: Policy, Monitor, Defender and Update Manager.

Right, an EKS cluster, in preview. The connector installs the Arc Kubernetes agents, they register, and you get an Arc-enabled Kubernetes cluster, Microsoft.Kubernetes/connectedClusters. Then you add Flux, Policy and the supported Kubernetes services.

Two things to say plainly: Arc does not turn EKS into AKS, and it does not take over AWS lifecycle management. Transition: now we do this with our AWS account.

PURPOSE

Show that an EC2 server and an EKS cluster become two different kinds of Arc resource, each with its own services.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/multicloud-connector/overview

## Slide 15: DEMO: add AWS resources through the Arc multicloud connector

KEY POINTS

• Distinguish discovered AWS inventory · Arc-connected EC2 server · Arc-connected EKS cluster
• Select source account · region · resources; show authorization path and bounded permissions without secrets
• Inspect Azure connector and selected solutions; trace source-cloud ID into discovered inventory
• Inspect matching EC2 HybridCompute machine and agent connection evidence
• Inspect EKS connectedClusters resource and cluster connection evidence
• Verify AWS_<AccountId> placement and shared landing-zone baseline; workloads remain in AWS
• Say: asynchronous discovery · connection · management differ; timestamps do not prove agent readiness
• → Next: reuse these identifiers in Policy and Flux; first, edge sites and legacy servers

TALKING POINTS

Before opening the portal, name the three outcomes the audience must distinguish: discovered AWS inventory, an Arc-connected EC2 server, and an Arc-connected EKS cluster. Identify the selected source account, region, and resources. Show the authorization artifact or deployment path without displaying secrets, and explain the bounded permissions used by the connector.

Inspect the Azure connector and its selected solutions. Walk one resource from its source-cloud identifier into discovered inventory and then into the appropriate operational Arc resource. For EC2, inspect the matching HybridCompute machine and agent connection evidence. For EKS, inspect the connectedClusters resource and cluster connection evidence. Do not describe a discovery timestamp as proof that agents are ready.

Inspect actual Azure placement, including the connector-created AWS_<AccountId> resource group, and verify that the shared landing-zone baseline covers it. This is where the AWS servers land in Azure management; the workloads themselves remain in AWS. Later management demonstrations must reuse these same source and Azure identifiers.

Connector operations are asynchronous: name the state each resource is actually in rather than compressing several states into one successful claim. Debrief the difference between discovering, connecting, and managing. Transition to edge sites and legacy servers.

PURPOSE

Prove the connector live. The audience should watch one AWS resource move from source identifier to discovered inventory to Arc resource, and be able to say which of the three states each resource is in. These same resources return later in the Policy and Flux demos.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/multicloud-connector/add-public-cloud
https://learn.microsoft.com/en-us/azure/azure-arc/multicloud-connector/onboard-multicloud-vms-arc
https://learn.microsoft.com/en-us/azure/azure-arc/multicloud-connector/onboard-elastic-kubernetes-service-clusters-arc

## Slide 16: Edge and legacy: Arc management still requires Azure connectivity

KEY POINTS

• Edge: remote does not mean disconnected.
• The site keeps working locally.
• Arc needs one outbound connection: direct, proxy, or Arc gateway (one endpoint to allow).
• Link drops: the workload keeps running; what Azure shows goes stale until it reconnects.
• Legacy: check support first: OS version, agent requirements, outbound access.
• Onboard one machine first, then widen.
• End-of-support Windows Server: ESUs through Arc.
• → Next: all four onboarding paths side by side.

TALKING POINTS

Two quick messages before we wrap up onboarding.

Left, edge sites. A remote site keeps doing its job locally; nothing about Arc changes that. But Arc is not a disconnected product: it needs one outbound connection to Azure. That can be direct, through a proxy, or through an Arc gateway, which means you only have to allow one endpoint through the firewall instead of a long list. And if the link drops, the workload keeps running, but what you see in Azure goes stale until the site reconnects, so read the timestamp before you trust it.

Right, legacy servers. Check support before you promise anything: the OS version, the agent requirements, and whether the server can reach Azure outbound. Onboard one machine first, watch it, then widen. And for end-of-support Windows Server, Arc is how you buy and receive Extended Security Updates.

Transition: that's every way in; here are all four onboarding paths side by side.

PURPOSE

Give the two practical caveats before closing the onboarding block: edge sites need an outbound path and go stale when it drops, and legacy servers need a support check and a careful start.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/servers/network-requirements

## Slide 17: One pattern, four onboarding paths

KEY POINTS

• Recap: you have now seen the on-premises path and the AWS path live.
• Same pattern everywhere: an agent goes in, an Azure resource comes out.
• On-premises: you install the agent → HybridCompute/machines.
• EC2: the connector installs it through AWS Systems Manager → HybridCompute/machines.
• EKS (preview): the connector installs the Arc Kubernetes agents → connectedClusters.
• GCP VM (preview): the connector installs it through GCP OS Config → HybridCompute/machines.
• Say: Inventory alone is not onboarding; only onboarding adds an Arc resource.
• → Next: part two, operate the service.

TALKING POINTS

This is the review of the onboarding block. You have now watched the on-premises path and the AWS path live; here they all are side by side, with GCP added.

Read down the middle column, because that is the only thing that really changes: who installs the agent. On-premises, you install it. For EC2, the connector installs it through AWS Systems Manager. For EKS, the connector installs the Arc Kubernetes agents, in preview. For GCP VMs, in preview, the connector installs it through GCP OS Config.

Then the right column: servers from anywhere become the same Azure resource type, HybridCompute machines, and EKS becomes a connected cluster. Same pattern everywhere: an agent goes in, an Azure resource comes out.

And the footer: Inventory on its own only lists resources; only onboarding gives you something you can manage. Transition: that closes the onboarding block; next, from managing to operating.

PURPOSE

Close the onboarding block with a recap the audience can now read easily: every path, side by side, after both demos.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview
https://learn.microsoft.com/en-us/azure/azure-arc/multicloud-connector/overview
https://learn.microsoft.com/en-us/azure/azure-arc/multicloud-connector/onboard-elastic-kubernetes-service-clusters-arc

## Slide 18: From managing to operating

KEY POINTS

• From managing to operating: the turn in the talk.
• So far, manage it: everything is connected to Azure (our servers, SCVMM VMs, AWS servers, the EKS cluster); we can see it and manage it in one place.
• Next, operate it: run the service on top of it; keep it working, protected, governed, affordable, and getting better.
• Strip: Observe · Secure · Govern · Cost · Adopt.
• Say: managing the estate is not the same as running the service.
• → Next: meet the service we operate.

TALKING POINTS

This is the turn in the talk. So far we have made the estate manageable: our on-premises servers, the SCVMM VMs, the AWS servers and the EKS cluster are all connected to Azure, and we can see and manage them in one place.

Now the real question: how do we operate it? Operating means running the service on top of all that: keeping it working, protected, governed, affordable, and getting better. The strip at the bottom is the five sections that answer it, and it will show you where we are.

Managing the estate is not the same as running the service. Transition: first, meet the service we operate.

PURPOSE

Mark the turn from making the estate manageable to operating the service, in one breath.

## Slide 19: Meet the service: IIC Hybrid Orders

KEY POINTS

• Meet the service we operate for the rest of the session: IIC Hybrid Orders.
• Infinite Improbability Corp is made up; the service is real and runs in our lab.
• What it does: order in a portal → checked on-premises → fulfilled and priced in AWS → done only when both answer.
• Azure: Front Door · portal (Container Apps) · coordinator (Functions) + Service Bus · Application Insights + Log Analytics.
• On-premises: validation worker cas26-lnx01 on the SCVMM cluster hvcl-ral-t1.
• AWS: second copy of the portal on EKS · fulfillment and pricing worker on EC2.
• Say: every section from here asks its question about this service.
• → Next: follow one order through it.

TALKING POINTS

Before we operate anything, meet the service. Infinite Improbability Corp, IIC, is a made-up company, but its order service is real: it runs in our lab, across all three estates.

What it does is simple. A customer places an order in a web portal. The order is checked against a private system that lives on-premises, it is fulfilled and priced in AWS, and it only counts as done when both of those answer.

Now where the pieces run. In Azure: Front Door is the one public entry, the portal runs on Container Apps, a coordinator on Azure Functions hands out the work through Service Bus queues, and Application Insights and Log Analytics watch it. On-premises: the validation worker, cas26-lnx01, one of the SCVMM VMs you saw earlier. In AWS: a second copy of the portal on the EKS cluster, and the fulfillment and pricing worker on EC2.

Remember this picture, because from here on every section asks its question about this service. Transition: let's follow one order through it.

PURPOSE

Give the audience the fictional company and the real service before the order walkthrough, so the rest of the rest of the session has a clear subject.

Sources:
lab/design/HYBRID-APPLICATION-HEALTH-DESIGN.md

## Slide 20: Arc made the estate manageable. Now operate the service.

KEY POINTS

• Shift from manageable resources to whether the service completes an order
• Customer uses Azure- or AWS-served portal; Azure coordinator assigns a correlation ID
• SCVMM-hosted on-premises worker validates; AWS worker fulfills and prices, in parallel
• Completion requires both answers, one correlation ID, inside the time target
• New order prevents recycled success; correlation ID links stages; time target captures customer experience
• Five questions: working, and where to look? · who may change it, and how is it protected? · which team owns it, and does it stay as agreed? · what does it cost, and how do we keep it in check? · did the fix work, and what do we keep doing?
• Tomorrow’s Whole-Service Observability session builds the IIC Azure Monitor Health Model
• → Next: Azure Monitor evidence for operating this fictional, three-cloud service

TALKING POINTS

Use this slide to make an explicit change of question. Until now we have asked how resources become manageable. We now ask whether the service they support delivers its intended result. Walk the order left to right. A customer opens the portal, served from Azure or from AWS, and places an order. The Azure coordinator gives it a correlation ID. The on-premises worker validates it and the AWS worker fulfills and prices it, in parallel. The order is complete only when both answer, with one correlation ID, inside the time target.

Explain why every part matters. A new order avoids reusing an old success. The correlation ID links every stage in every cloud to this one attempt. The time target separates an eventual answer from the experience the customer was promised. Infinite Improbability Corp is fictional; the pattern of a customer outcome that depends on three clouds is not.

Then read the five questions under it, one per section, in the same words as slide 4: is it working, and where do you look? Who is allowed to change it, and how is it protected? Which team owns it, and does it stay the way we agreed? What does it cost, and how do we keep it in check? Did the fix work, and what do we keep doing?

The same SCVMM-hosted workload remains in the story. Transition into Azure Monitor as the platform that helps gather and interpret the evidence required for those questions.

Plug the companion session here, once: tomorrow's Whole-Service Observability session takes this exact order apart with an Azure Monitor Health Model, the modern successor to a SCOM distributed application. Today we operate it.

PURPOSE

Change the question from 'can we manage these resources' to 'does the service work'. This is the hinge of the session. The audience should see the whole IIC order path across three clouds, and the five operating questions that the monitoring, security, governance and cost sections answer in turn.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview
https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/overview

## Slide 21: 1 · Observe: is it working, and where do you look?

KEY POINTS

• Section 1 of 5: Observe. The question: is it working, and where do you look?
• Coming up: Azure Monitor · green servers, broken service · machine health to service health · where to ask · a demo that reads both.
• → Next: Azure Monitor from collection to decision.

TALKING POINTS

Section one of five: observe. The question for this section: is it working, and where do you look? Coming up: Azure Monitor, where the data comes from, where it lands and how it is used; why green servers can hide a broken service; how machine health rolls up into service health; the two places to ask questions; and a demo that reads both. The strip at the bottom shows where we are. Transition: Azure Monitor from collection to decision.

PURPOSE

Signal the start of section 1, Observe, with its question, so the audience knows where they are.

## Slide 22: Azure Monitor: follow the data from collection to decision

KEY POINTS

• Where do you look? One platform: Azure Monitor.
• Data comes from three places: our servers (the agent) · Azure services (automatic) · the app itself (Application Insights).
• It lands as logs and metrics.
• You use it for dashboards and alerts, a health model, security analytics.
• Say: collecting data switches nothing on by itself; each use needs its own setup.
• Say: this is the overview; tomorrow's Whole-Service Observability session goes deep.
• → Next: how a server's data actually gets in.

TALKING POINTS

The section question is: is it working, and where do you look? The answer to "where" is one platform, Azure Monitor. Read this slide left to right.

Collect. Everything we want to see comes from three places. Our servers, on-premises and in AWS, run the Azure Monitor agent, which sends their logs and counters. Azure services like Front Door, Functions and Service Bus report their own metrics automatically; you do not install anything. And the app itself reports each step of every order through Application Insights.

Store. It lands as logs and as metrics.

Use. You use it for dashboards and alerts, for a health model that answers "is the order working?", and for security analytics in Sentinel. Each of those needs its own setup; collecting data does not switch anything on by itself.

That is the overview. Tomorrow's Whole-Service Observability session takes this apart properly. Transition: how a server's data actually gets in.

PURPOSE

Answer "where do you look" in one plain picture: three sources, one platform, a few uses. Keep it high level.

Sources:
https://learn.microsoft.com/en-us/azure/azure-monitor/overview
https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview
https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/azure-monitor-workspace-overview
https://learn.microsoft.com/en-gb/azure/azure-monitor/metrics/data-platform-metrics
https://learn.microsoft.com/en-us/azure/azure-monitor/vm/metrics-opentelemetry-guest

## Slide 23: How a server's data gets in: agent + rule

KEY POINTS

• How a server's data gets in: agent + DCR.
• Events, Syslog and counters → the Azure Monitor agent.
• Data collection rule (DCR): what to collect and where to send it.
• DCR association: assigns the rule to this server; it configures the agent.
• Logs + counters → Log Analytics; metrics (preview) → an Azure Monitor workspace.
• Say: agent + DCR = data. No DCR, no data: the first thing to check when a chart is empty.
• → Next: green servers, broken service.

TALKING POINTS

One message on this slide: installing the agent collects nothing on its own.

On the left, inside the server: events, Syslog and counters, and the Azure Monitor agent. In the middle, the two things that tell the agent what to do, with the names you will see in the portal. A data collection rule, a DCR, says what to collect and where to send it. A DCR association assigns that rule to this server, and that is what configures the agent.

Then the data flows right: logs and counters to a Log Analytics workspace, and metrics, in preview, to an Azure Monitor workspace.

So: agent plus DCR equals data. No DCR, no data. When a chart is empty, that is the first thing to check. Transition: green servers, broken service.

PURPOSE

Make the DCR concrete, with its portal name, so an empty chart has an obvious first check.

Sources:
https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview
https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview
https://learn.microsoft.com/en-gb/azure/azure-monitor/metrics/data-platform-metrics
https://learn.microsoft.com/en-us/azure/azure-monitor/vm/metrics-opentelemetry-guest

## Slide 24: Green servers, broken service

KEY POINTS

• Green servers, broken service.
• Arc says connected: we can manage the server; can be green while orders fail.
• Data is arriving: we can see the server and the app; can be red while orders still work.
• Orders complete: checked by a fresh order end to end; proves the service works.
• Say: most teams judge health by their machines; customers use the service.
• Say: check the service, not just the servers.
• → Next: how the server checks roll up into one answer for the service.

TALKING POINTS

Here is the point: "the server looks fine" is not the same as "the service works".

Most teams judge health by their machines. Arc says connected, the dashboard has data, so it must be fine. But customers do not use machines; they use the service.

Three checks, and they can disagree in either direction. Arc says connected means we can manage the server; it can be green while orders fail. Data is arriving means we can see the server and the app; it can be red while orders still work. Orders complete, checked by placing a fresh order and watching it finish, is the only one that proves the service works.

Give the example. The AWS worker's queue is broken: Arc is green, logs are arriving, and no order finishes. If you only look at the first two, you tell the business everything is fine while customers cannot order. The other way round: someone deletes a DCR, the dashboard goes red, and customers are fine.

Check the service, not just the servers. Transition: how those checks roll up into one answer for the service.

PURPOSE

Make the audience stop equating green servers with a working service, before building the service view.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview
https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview

## Slide 25: From signals to machine health to service health

KEY POINTS

• Commitment: complete an IIC order across Azure · on-premises · AWS
• Required branches: Functions/Service Bus coordination · SCVMM validation · Arc-enabled EC2 fulfillment
• Order evidence: stage results · latency · one correlation ID; every branch must answer
• Machine evidence: heartbeat · guest signals support, but cannot prove timely order validation
• States: Healthy · Degraded · Unhealthy follow evidence; missing evidence stays Unknown
• SCOM lesson: model customer impact; alert on order outcome, route component alerts to owners
• Avoid duplicate stage records across workspaces and stale green; Health Models preview status applies
• → Next: pair resource queries with machine and service evidence

TALKING POINTS

Read the slide top down. At the top is the commitment: customers can complete an IIC order. It depends on three required branches: Azure coordination (Functions and Service Bus), on-premises validation on the SCVMM-hosted worker, and AWS fulfillment on the Arc-enabled EC2 worker. If any branch is not Healthy, the order is degraded, no matter how green the other two are.

Now the two lines under the boxes: two kinds of evidence. Order evidence is the result and latency of each stage, tied together by one correlation ID; it describes what the customer experiences. Machine evidence is heartbeat and guest signals; it describes the servers that carry the work. Machine evidence supports the answer but never is the answer: a heartbeat proves a reporting path and a CPU figure describes load, but neither proves that the on-premises worker validated this order in time.

Then the four states along the bottom. Healthy, Degraded and Unhealthy come from evidence. Unknown means the evidence is missing, and it must stay visible as Unknown rather than turn into a stale green. A connected Arc badge is not a healthy service.

The SCOM lesson is no longer on the slide; say it. For anyone who ran SCOM, keep the service model and drop three habits. Alert fatigue: alert once on the order outcome, not on every machine signal, and send component alerts to their owners. Duplicated collection: one collection path per question. Blind spots: a worker that stops reporting shows as Unknown, not green. Close on the footer. Azure Monitor Health Models provides that service context today; state its preview status where it applies. Tomorrow's Whole-Service Observability session builds this model and breaks it on purpose. Transition: where you get that evidence, the places to ask questions.

PURPOSE

Show the difference between healthy machines and a working service, using the IIC order. The audience should see that the order is the commitment, every cloud's piece is a required dependency, machine evidence only supports the answer, and missing evidence shows as Unknown rather than green. The next demo reads this on real data.

Sources:
https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/overview
https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/rollup

## Slide 26: Two places to ask questions

KEY POINTS

• Resource Graph answers what exists; Monitor queries answer what has fresh evidence
• Resource Graph’s KQL subset queries Azure representations, not Log Analytics tables
• Inventory: resource ID · group · location · tags · extensions · exposed status
• Say: control-plane facts do not provide guest CPU, OS events, requests, or dependency history
• Evidence: Log Analytics/KQL · Prometheus/PromQL · supported platform-metrics queries
• Compare expected resources with telemetry using identifier · time range · freshness
• Say: represented machines without fresh evidence are investigation gaps, not healthy results
• → Next: interpret machine evidence alongside service health

TALKING POINTS

Now where the evidence comes from: two places to ask questions. Resource Graph tells you what exists and how it is set up, for example which servers are connected and which have the agent. Azure Monitor tells you what happened: events, heartbeats and orders.

Start with two questions: 'Which Arc machines exist in our scope?' and 'Which machines have fresh operating evidence?' The first belongs to resource inventory; the second requires monitoring data. Azure Resource Graph queries Azure resource representations using its supported KQL subset. Log Analytics also uses KQL, but against different tables and a different data source. Similar syntax does not make the datasets interchangeable.

On the Resource Graph side, show resource ID, resource group, location, tags, extensions, and the exposed status properties available for the selected resource type. Be precise that these are control-plane facts, subject to the service's update behavior. They do not provide the full history of guest CPU, operating-system events, application requests, or dependencies.

On the monitoring side, map each question to its store: Log Analytics records through KQL, Prometheus metrics through PromQL, and platform metrics through their supported query experience. Include the resource identifier, time range, and freshness test in the explanation.

The combined operating pattern is to identify the expected resource set first and then compare its telemetry coverage. A represented machine with no fresh evidence is an investigation gap, not an automatic healthy result. Transition: prove it live, with the Resource Graph queries and then machine and service health.

PURPOSE

Separate resource facts from operating evidence before the demo. Attendees should know that Resource Graph answers 'what exists and how is it configured' and monitoring queries answer 'what is happening now', and that both look like KQL but read different data.

Sources:
https://learn.microsoft.com/en-us/azure/governance/resource-graph/overview
https://learn.microsoft.com/en-us/azure/governance/resource-graph/concepts/query-language
https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview

## Slide 27: DEMO: query the estate, then read machine and service health

KEY POINTS

• Prove represented configuration first, then currently observed health.
• Run Resource Graph at intended subscription/resource-group scope; find on-premises and AWS representations.
• Read stable IDs · tags · extensions · exposed state; metadata, not performance history.
• Check monitoring scope · time range; select the workload machine · query family · store.
• Show latest observation · machine condition · application/request evidence · IIC Health Model; tomorrow: Whole-Service Observability.
• Compare machine signal · component · IIC order; place order, read correlation ID · stage results.
• Treat empty/stale panels as coverage gaps; debrief impact · freshness · owner · next action · recovery condition.
• → Next: Who is authorized for the next action?

TALKING POINTS

Announce the two-part demonstration: first prove what is represented and configured, then prove what is currently observed. Run the saved Resource Graph query against the intended subscription or resource-group scope. Identify the on-premises and AWS representations, their stable IDs, tags, relevant extensions, and exposed state. Explain that this result is resource metadata, not a historical performance report.

Open the monitoring view and inspect the scope and time range before reading any colored indicator. Select the workload machine and identify the query family and store behind its evidence. Show the latest observation time, the relevant machine condition, and the application or request evidence. Name the IIC Health Model behind the view; tomorrow's Whole-Service Observability session shows how it is built.

Spend the extra minute here, on the service-health view: put a machine signal next to the order outcome and read them together. Move from machine to component to the IIC order. Place a new order and read its new correlation ID and the result of each stage. An empty or stale panel is a coverage issue to investigate, not a green result.

Debrief with impact, evidence freshness, owner, next action, and the recovery condition. This is where alert ownership belongs in the story. Transition to who is authorized to perform that next action.

PURPOSE

Prove the monitoring overview live in two parts: what is represented, then what is observed. The audience should see a fresh result tied to an owner and a next action, which is also where alert ownership enters the story.

Sources:
https://learn.microsoft.com/en-us/azure/governance/resource-graph/overview
https://learn.microsoft.com/en-us/azure/azure-monitor/overview
https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/overview
https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/rollup

## Slide 28: 2 · Secure: who is allowed to change it, and how is it protected?

KEY POINTS

• Section 2 of 5: Secure. The question: who is allowed to change it, and how is it protected?
• Coming up: access (four doors, four keys; who holds which key) · protection (Defender for Cloud) · detection (Microsoft Sentinel).
• Three demos: Azure RBAC access, a Defender finding, a Sentinel incident.
• → Next: security starts with who can access which resource.

TALKING POINTS

Section two of five: secure. Securing a hybrid service is two things, and the question says both: who is allowed to change it, and how is it protected? First access: who can open which door into a server, and who holds which key in our app. Then protection: Defender for Cloud finds weaknesses and threats on the servers, and Microsoft Sentinel turns security data into incidents someone owns. Three demos along the way. The strip at the bottom shows where we are. Transition: security starts with who can access which resource.

PURPOSE

Open the security section with both halves of security, access and protection, so Defender and Sentinel have a place in the story.

## Slide 29: Security starts with who can access which resource

KEY POINTS

• One server, four separate doors; each door has its own key. The doors are not an order: they sit side by side.
• Azure: lets you see or change it in the portal · key = an Azure role
• Sign in: lets you log on to Windows/Linux · key = the server's own accounts
• Hosting: lets you stop, move or delete the VM · key = SCVMM or AWS admin
• App + data: lets you use the app or read its data · key = the app's own permissions
• Say: being an Azure admin does not let you log on to the server.
• The trap: Run Command or extension rights = admin inside the server. Treat them as admin.
• Ask the room: who in your org holds the Azure key and the server key at the same time?
• → Next: who holds which key: three rules for any estate.

TALKING POINTS

Keep this simple. Take one server, say cas26-lnx01, and picture four doors into it.

Door one is Azure. Someone with an Azure role can see the server in the portal, tag it and manage it as an Azure resource. Door two is signing in to Windows or Linux. That uses the server's own accounts, RDP or SSH, exactly as it did before Arc. Door three is the hosting platform. Whoever is an admin in SCVMM or in the AWS account can stop, move or delete the VM, whatever Azure says. Door four is the application and its data, which has its own permissions.

The point of the slide: a key to one door does not open the others. Being an Azure admin does not let you log on to the server, and being a local admin on the server gives you nothing in Azure. Arc did not merge these doors; it added the first one.

Now the one trap, and it is the thing to remember from this slide. If your Azure role lets you run commands or install extensions on the server, you can run code on it as an administrator without ever logging on. So treat that Azure role as admin access to the server and hand it out the same way.

Ask the room who in their organization holds both the Azure key and the server key. Transition: three rules for who holds which key, in any estate.

PURPOSE

Open security with one simple idea: access to a hybrid server is four separate doors with four separate keys, plus one trap where an Azure role becomes admin inside the server.

Sources:
https://learn.microsoft.com/en-us/azure/role-based-access-control/overview
https://learn.microsoft.com/en-us/azure/azure-arc/servers/security-identity-authorization
https://learn.microsoft.com/en-us/azure/azure-arc/servers/security-extensions

## Slide 30: Who holds which key: three rules for any estate

KEY POINTS

• Three rules for any estate: people, machines, fix-up tools.
• People: read-only by default; admin only when asked for, time-limited, after MFA (PIM).
• In our app: a stolen operator login can look but not change anything.
• Machines and apps: their own identity, only what they need, no stored passwords.
• In our app: each IIC worker reads its own queue and posts results, nothing else.
• Fix-up tools: change one thing, in one place, every change logged.
• In our app: the Policy fix-up robot changes tags in one resource group.
• Take-home: list every identity that can change a server; check it against the three rules.
• → Next: demo, read-only versus admin on a real Arc server.

TALKING POINTS

These are three rules you can take back to your own estate. Read the rule first, then how our app does it.

People: admins and operators are read-only by default. When they need to change something, they ask for admin rights through Privileged Identity Management, get them for a limited time after MFA, and then they expire. In our app, a stolen operator login can look at everything but change nothing.

Machines and apps: every machine or app gets its own identity, only the permissions it needs, and no stored passwords. In our app, each IIC worker signs in with its own Arc machine identity and can read its own queue and post results, nothing else. A hacked worker gets one queue.

Fix-up tools: anything that changes things for you can change one thing, in one place, and every change is logged. In our app, the Policy fix-up robot can change tags in one resource group only.

That is Zero Trust in practice: check who it is, give the smallest key for the shortest time, and assume something will be compromised. The take-home: list every identity that can change a server and check it against these three rules. Transition: the demo shows the people rule live.

PURPOSE

Give the audience three rules they can apply to their own estate, with the IIC app as proof that they work.

Sources:
https://learn.microsoft.com/en-us/azure/role-based-access-control/overview
https://learn.microsoft.com/en-us/azure/azure-arc/servers/security-identity-authorization
https://learn.microsoft.com/en-us/azure/azure-arc/servers/security-extensions
https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure

## Slide 31: DEMO: prove access to an Arc resource with Azure RBAC

KEY POINTS

• Same CAS26 resource · two approved role contexts · one reversible operation.
• Show resource ID · scope; Reader reads, then attempts denied management operation.
• Explain required operation · role; switch approved management context, recheck identity · permission.
• Say: Use runbook-selected tag/extension action; no broad role changes or weakened production assignments.
• Inspect resource state · Azure Activity Log; identify successful actor and authorization boundary.
• If shown, test guest access separately using its own credentials or supported role path.
• Reset temporary CAS26 changes; debrief identity · role · scope · allowed/denied actions · evidence.
• → Next: Security findings that help prioritize action.

TALKING POINTS

Set up the contrast before changing anything: the same CAS26 resource, two approved role contexts, and one reversible operation. Show the resource ID and effective scope. In the reader context, perform a permitted read and then attempt the selected management operation that should be denied. Explain the denial in terms of the required operation and role, not as an unexplained portal error.

Move to the management context or approved scoped activation. Recheck the effective identity and permission, then perform the bounded action. Use the runbook's selected tag or extension action; do not improvise broad role changes or weaken a production assignment to create the demonstration.

Inspect the resulting resource state and Azure Activity Log evidence. The comparison should prove the authorization boundary and identify the successful actor.

If guest access is also shown, introduce it as a separate test with its own credentials or supported role path. Reset only temporary CAS26 changes. Debrief identity, role, scope, allowed action, denied action, and observed evidence. Transition from who may act to the security findings that help prioritize action.

PURPOSE

Prove the authorization boundary live with two identities and one reversible action. The audience should see a denied action, an allowed action, and the activity log record that identifies who acted.

Sources:
https://learn.microsoft.com/en-us/azure/role-based-access-control/overview
https://learn.microsoft.com/en-us/azure/azure-arc/servers/security-identity-authorization
https://learn.microsoft.com/en-us/azure/azure-arc/servers/security-extensions

## Slide 32: Defender for Cloud

KEY POINTS

• Defender for Cloud: shows what is weak and what is under attack, on every connected server.
• Turn it on: an Arc-connected server + the Defender for Servers plan.
• On the server: the plan installs Defender for Endpoint, the sensor on the machine.
• What you get: what's weak (posture: recommendations, vulnerabilities) and what's under attack (protection: security alerts).
• An owner decides: fix the weakness, or respond to the attack.
• Say: Defender for Cloud is the dashboard in Azure; Defender for Endpoint is the sensor on the server.
• → Next: inspect one finding on a real Arc-enabled server.

TALKING POINTS

Say it as one chain, left to right.

Turn it on: the server is connected to Arc, and you turn on the Defender for Servers plan in Defender for Cloud.

On the server: the plan installs Defender for Endpoint, the sensor that sits on the machine and watches it.

What you get, two kinds of result in plain words. What is weak, which Microsoft calls posture: recommendations and vulnerabilities. What is under attack, which Microsoft calls protection: security alerts.

An owner decides: fix the weakness, or respond to the attack.

The line under the diagram is the one to remember: Defender for Cloud is the dashboard in Azure; Defender for Endpoint is the sensor on the server.

For questions: without the plan and the sensor there are no vulnerability findings or alerts from this path, although the free foundational CSPM recommendations still appear. A recommendation is not a security alert, and neither is a Sentinel incident. Transition: inspect one finding on a real Arc-enabled server.

PURPOSE

Explain Defender for Cloud and Defender for Endpoint as one chain, and posture and protection in plain words.

Sources:
https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-cloud-introduction
https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-servers-overview
https://learn.microsoft.com/azure/defender-for-cloud/concept-cloud-security-posture-management

## Slide 33: DEMO: inspect a Defender for Cloud finding for an Arc-enabled server

KEY POINTS

• Inspect a real finding on the runbook’s Arc-enabled EC2 server.
• Verify exact resource identity · coverage setting · evidence capability · recency.
• Open one recommendation, vulnerability observation, or protection finding; name its type.
• Identify affected resource · significance · supporting evidence · relevant attack-path context.
• Identify owner and bounded remediation; no disruptive change required.
• Verify with corrected configuration · updated assessment · other fresh evidence.
• Say: Dismissing a finding does not fix its underlying condition.
• → Next: Sentinel coordinates investigation of connected security evidence.

TALKING POINTS

Open with the exact Arc resource named in the runbook, an Arc-enabled EC2 server, and verify its identity before reading the finding. Show the relevant coverage or environment setting and explain which capability is supplying the evidence. Confirm recency; an old assessment is not a current statement about the resource.

Open one applicable recommendation, vulnerability observation, or protection finding and name its type. Explain the affected resource, why the issue matters, and what evidence supports the assessment. Where an attack path or related context is available and relevant, use it to clarify priority rather than opening a new unexplained feature tour.

Identify the owner and the bounded remediation decision. The demo may inspect the finding without applying a disruptive change. State what would establish success: a corrected configuration, updated assessment, or other appropriate fresh evidence. Do not claim that dismissing an item fixes the underlying condition.

Debrief coverage, finding type, affected resource, owner, and verification. Transition to Sentinel as the place where connected security evidence can become a coordinated investigation.

PURPOSE

Show a real Defender finding on an Arc-enabled server and turn it into an owned action. The audience should see coverage, finding type, affected resource, owner, and what fresh evidence would prove the issue fixed.

Sources:
https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-cloud-introduction
https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-servers-overview

## Slide 34: Microsoft Sentinel

KEY POINTS

• Microsoft Sentinel turns security data into detections and incidents.
• From your servers: security events, through the Azure Monitor agent + DCR.
• From cloud services (Entra, Azure, Microsoft 365, SaaS): through data connectors.
• Both land in one Log Analytics workspace with Sentinel enabled.
• Analytics rule → incident with entities and evidence → investigation and response owner.
• Say: no data and no rule means no incident.
• → Next: investigate a labelled training incident.

TALKING POINTS

Data reaches Sentinel two ways, one row each on the left.

From your servers: their security events travel through the Azure Monitor agent, with a DCR telling it what to collect. That is the same agent and DCR we saw in the monitoring section.

From cloud services, such as Entra sign-ins, Azure activity, Microsoft 365 and other SaaS: there is no agent; you turn on a data connector in Sentinel.

Both land in one Log Analytics workspace with Sentinel enabled. A scheduled analytics rule looks for trouble, and when it finds some and is set to create one, you get an incident with its entities and evidence, and an owner who investigates and responds.

No data and no rule means no incident. Keep the boundary clear: Sentinel does not replace Defender for Cloud posture management or Azure RBAC. Transition: investigate a labelled training incident.

PURPOSE

Show the two ways security data reaches Sentinel, then how a rule turns it into an owned incident.

Sources:
https://learn.microsoft.com/en-us/azure/sentinel/overview
https://learn.microsoft.com/azure/sentinel/microsoft-sentinel-defender-portal

## Slide 35: DEMO: investigate a Microsoft Sentinel incident

KEY POINTS

• Say: CAS26 incident is training, not a live attacker action.
• Confirm Sentinel environment · workspace · time range; open incident in Microsoft Defender portal.
• Trace CAS26 training analytics rule to labelled event on Windows guest cas26-arcwin01.
• Inspect triggering records · host or account · workload map · entities · timeline.
• Separate observed activity and grouping evidence from analyst hypothesis.
• Assign owner and response decision; identify playbook identity and permissions if discussed.
• Show status · closure or escalation evidence; reset only runbook-approved CAS26 artifact.
• → Next: Governance needs agreed scope · shared baseline · repeatable compliance rules.

TALKING POINTS

Identify the CAS26 training boundary immediately. Confirm the Sentinel environment, workspace, and time range, then open the CAS26 training incident in the Microsoft Defender portal. Do not describe a synthetic or training event as a live attacker action. Explain that the incident came from the CAS26 training analytics rule, triggered by a labelled training event written on the Windows guest cas26-arcwin01.

Inspect the triggering evidence and compare the relevant host or account identity with the workload map. Walk the entities and timeline far enough to answer what activity was observed and why it was grouped into this incident. Separate the analyst's hypothesis from the records actually present.

Assign or inspect the responsible owner and record a response decision. If a playbook is discussed, identify its execution identity and the permission boundary before implying that an automated action can run. The demo need not perform a disruptive response to prove that the investigation process is understandable.

Finish by showing the status and the evidence that would justify closure or escalation. Reset or close only the CAS26 training artifact according to the runbook. Transition to governance: dependable security response requires an agreed resource scope, shared baseline, and repeatable compliance rules.

PURPOSE

Walk a labelled training incident from evidence to owner to decision. The audience should see how an analyst reads an incident and records a response, and that the training event is clearly not an attack.

Sources:
https://learn.microsoft.com/en-us/azure/sentinel/overview
https://learn.microsoft.com/en-us/azure/sentinel/investigate-cases
https://learn.microsoft.com/azure/sentinel/microsoft-sentinel-defender-portal

## Slide 36: 3 · Govern: which team owns it, and does it stay the way we agreed?

KEY POINTS

• Section 3 of 5: Govern. The question: which team owns it, and does it stay the way we agreed?
• Coming up: ownership (landing zones) · rules (Azure Policy) · compliance against a standard · kept current (patching, ESUs) · kept as designed (Flux on EKS).
• Demos: Policy, Update Manager, Flux.
• → Next: what Microsoft means by a landing zone.

TALKING POINTS

Section three of five: govern. Governance is two things, and the question says both: which team owns it, and does it stay the way we agreed? Ownership comes from the landing zone: where a resource lives decides who owns it and which rules apply. Then staying the way we agreed: Azure Policy checks and fixes settings everywhere, compliance proves it against a standard, one patch process keeps every estate current, and Flux keeps the EKS cluster as designed. Three demos along the way. Transition: what Microsoft means by a landing zone.

PURPOSE

Open the governance section with both halves, ownership and staying as agreed.

## Slide 37: A landing zone is the operating foundation for workloads at scale

KEY POINTS

• What Microsoft means by a landing zone.
• Microsoft's definition: "A proven and flexible architecture for governing, securing, and scaling a multi-subscription Azure environment."
• Platform landing zone: management groups plus shared services (connectivity, identity, security monitoring, management); usually one per Entra tenant.
• Application landing zones: one per workload, holding its dev, test and prod environments.
• Guardrails are inherited: Policy on the management groups applies to every subscription below.
• Built with Microsoft's accelerators, or a custom build.
• → Next: Arc resources land in an application landing zone too.

TALKING POINTS

This is a general overview of what Microsoft means by a landing zone. Start on the left.

At the top is the Entra tenant. Under it are management groups, which are folders you set rules on. One is the platform: its subscriptions hold the shared services, identity, connectivity and management. The other is landing zones, and under it sit the application landing zones: each workload gets its own, with its own dev, test and production subscriptions. That green box is where workloads land.

Now the right side, in Microsoft's own words. Microsoft defines an Azure landing zone as "a proven and flexible architecture for governing, securing, and scaling a multi-subscription Azure environment." It has two parts. The platform landing zone is the central foundation: the management group hierarchy plus shared services such as connectivity, identity, security monitoring and management, and most organizations have only one per Entra tenant. Application landing zones are one per workload, holding all of its environments. Guardrails are inherited: Policy set on the management groups applies to every subscription below. You build it with Microsoft's accelerators or a custom build.

For questions: Microsoft organizes the design into eight design areas, billing and tenant, identity and access, resource organization, network topology and connectivity, security, management, governance, and platform automation and DevOps. Transition: Arc resources land in an application landing zone too.

PURPOSE

Define an Azure landing zone in Microsoft's own words, so the Arc landing zone slide that follows makes sense.

Sources:
https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/

## Slide 38: Azure Arc landing zone

KEY POINTS

• Azure Arc landing zone: the accelerator adapts the landing zone foundation for hybrid and multicloud.
• Arc resources sit in an application landing zone subscription and inherit its Policy and access.
• On-premises workloads in their resource group; AWS resources in the resource group the connector created.
• Seven design areas; Network means how agents reach Azure, not Azure VNets.
• Agent paths: straight out on HTTPS 443, through your proxy (Arc gateway cuts it to eight addresses), or privately through Private Link over ExpressRoute or VPN.
• Say: the accelerator does not move the workload; it runs where it runs.
• → Next: Azure Policy, the rules those resources inherit.

TALKING POINTS

The Azure Arc landing zone accelerator for hybrid and multicloud is Microsoft's guidance for running Arc resources inside the landing zone from the previous slide.

Top box: an application landing zone subscription, which inherits Policy and access. Under it, the on-premises workload resource group with the SCVMM workloads, and the AWS resource group that the connector created, with the EC2 machines and the EKS cluster. Where you place them decides the Policy they inherit and who can see or manage them.

The strip at the bottom is the seven design areas in Microsoft's Arc-enabled servers guidance. One needs a word: network. You do not build Azure networks for Arc. Network here means how the agent on your server reaches Azure, and you decide it in your datacenter and in AWS: straight out on HTTPS 443, through your proxy or firewall, where Arc gateway cuts the addresses you have to allow down to eight, or privately through Private Link over ExpressRoute or VPN, which is the only option that needs a private endpoint in an Azure virtual network.

The accelerator does not move the workload or remove the source environment's ownership. Transition: Azure Policy, the rules those resources inherit.

PURPOSE

Place Arc resources in the landing zone, and explain what the network design area means for Arc.

Sources:
https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/
https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-servers/eslz-arc-servers-connectivity

## Slide 39: Azure Policy

KEY POINTS

• Azure Policy: rules you set once and Azure checks everywhere.
• Write a rule once; assign it to a management group, subscription or resource group; everything below inherits it.
• Azure checks every resource (Azure, Arc on-premises, Arc in AWS), reports who complies, and can block or fix what does not.
• Like a GPO, but: a GPO sets Windows settings on domain-joined machines; Azure Policy governs the Azure resource itself (tags, location, size, features), not inside the OS.
• Machine configuration (was guest configuration) reaches inside the OS, Windows and Linux; assigned through Azure Policy; the closest thing to a GPO.
• Examples: require an Owner tag (our demo) · allowed locations · Azure Monitor agent missing · password or TLS rules inside the server.
• Say: Azure Policy checks the resource; machine configuration checks inside the server.
• → Next: how Azure Policy works, walked with the Owner-tag policy.

TALKING POINTS

Before how it works, what it is. Azure Policy is rules you set once and Azure checks everywhere. You write a rule once and assign it to a management group, a subscription or a resource group, and everything under it inherits the rule: Azure resources and Arc servers, on-premises and in AWS. Azure checks every resource against it, reports who complies, and can block or fix what does not.

Most of you know Group Policy, so compare. The idea is the same: a rule assigned at a scope and inherited down. The difference is what it controls. A GPO sets settings inside Windows on domain-joined machines. Azure Policy governs the Azure resource itself: its tags, its location, its size, whether a feature is on. It does not reach inside the operating system.

The part that does is machine configuration, formerly guest configuration. It checks settings inside the operating system, on Windows and Linux, on Azure VMs and Arc servers, domain-joined or not, and it is assigned through Azure Policy. That is the closest thing to a GPO.

Four examples along the bottom: require an Owner tag, which adds the tag if it is missing and is the one in our demo; allowed locations, which blocks creating resources in the wrong region; Azure Monitor agent missing, which reports it or installs it; and a machine configuration rule for password or TLS settings inside the server. Transition: how Azure Policy works, walked with that Owner-tag policy.

PURPOSE

Introduce Azure Policy at a high level, compared with Group Policy, and separate it from machine configuration before the mechanics.

Sources:
https://learn.microsoft.com/en-us/azure/governance/policy/overview
https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview/01-overview-concepts

## Slide 40: How Azure Policy works

KEY POINTS

• How Azure Policy works, walked with the Owner-tag policy from the demo.
• Policy flow: definition and effect · initiative · scoped assignment · evaluation · compliance.
• Assignments carry parameters · exclusions · exemptions; effects determine what follows evaluation.
• Effects: Audit records · Deny blocks · Modify changes · DeployIfNotExists deploys related resources.
• Modify and DeployIfNotExists need a permitted remediation identity; existing resources may need remediation.
• Guest configuration has additional requirements for controls inside a machine.
• Default enforces matching writes; DoNotEnforce evaluates and permits manual remediation without write-time effects.
• Owner-tag assignments use DoNotEnforce; Default Modify may correct tags before NonCompliant appears.
• → Next: compliance, proving it against a standard.

TALKING POINTS

Walk the diagram box by box with the Owner-tag policy from the demo: the definition is "Require an Owner tag"; the assignment puts it on the operations resource group; evaluation finds cas26-arcwin01 has no Owner tag; the reason is that the tag is missing; the remediation task uses Modify to add it; and after the fix a fresh check agrees.

Read the Policy flow in order. A definition describes a condition and effect. An initiative groups related definitions. An assignment applies the chosen policy or initiative at a scope with parameters and any configured exclusions or exemptions. Evaluation produces compliance information; the effect determines what happens when its conditions are met.

Contrast the effects using operational language. Audit records noncompliance. Deny can prevent a noncompliant request where supported. Modify can alter supported properties under the policy's conditions. DeployIfNotExists can deploy a related required resource after its conditions and checks are satisfied. These effects are not interchangeable, and an assignment does not mean every existing resource has already been corrected.

Explain the remediation identity for applicable Modify and DeployIfNotExists cases. It needs the required permissions at the relevant scope. Existing noncompliant resources can require a remediation task, followed by fresh evaluation. Guest configuration adds its own requirements where the intended control concerns state inside the machine.

Use the demo's Arc resource as the anchor and identify the actual definition, effect, and target property. Transition to the demo, which proves both the changed resource state and the updated compliance result rather than relying on a completed task status alone.

Add enforcement mode before the demo, because it decides what the audience will see. Default enforces the effect on every create or update of a matching resource; DoNotEnforce still evaluates compliance and still allows manual remediation tasks, but the effect does not fire on writes. In Default mode a Modify policy corrects a missing tag when a matching resource is created or updated, so the operator may not see a NonCompliant state; an existing resource is corrected only by a remediation task. The session's two Owner-tag assignments run in DoNotEnforce for that reason, which is also the recommended way to introduce any Modify or DeployIfNotExists policy safely.

PURPOSE

Teach Azure Policy well enough that the audience can read the demo that follows: definition, assignment, effect, remediation identity and enforcement mode. Enforcement mode matters most, because it decides whether the audience sees a noncompliant machine at all.

Sources:
https://learn.microsoft.com/en-us/azure/governance/policy/overview
https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources
https://learn.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure#enforcement-mode

## Slide 41: Compliance

KEY POINTS

• Compliance: prove it against a standard.
• In Azure (what this session shows): Azure Policy writes the rules (built-in regulatory initiatives, reaching Arc servers and inside the OS).
• Defender for Cloud keeps the score: regulatory compliance dashboard across Azure, Arc on-premises, AWS and GCP.
• Cost: cloud security benchmark free; other standards need a paid Defender plan (not Defender for Servers Plan 1).
• Organization-wide (optional): Purview Compliance Manager adds Microsoft 365, improvement actions and auditor reports.
• Cost: comes with Microsoft 365, but most standards templates are extra (E5 includes three).
• Standards: NIST 800-53 · NIST CSF 2.0 · CIS · PCI DSS 4.0 · ISO 27001 · SOC 2 · HITRUST · NIS2 · GDPR.
• Say: you do not need Purview to do compliance; a compliance score is evidence for an auditor, not a certificate.
• → Next: see one of those rules evaluated and fixed on real servers.

TALKING POINTS

Compliance is the second half of Govern's question, does it stay the way we agreed, when the thing you agreed to is a regulation.

Left half, in Azure, which is what this session shows. Azure Policy writes the rules: built-in regulatory initiatives turn a standard into policy, and they reach Arc servers too, including settings inside the operating system. Defender for Cloud keeps the score: its regulatory compliance dashboard covers Azure, Arc on-premises, AWS and GCP. Cost: the Microsoft cloud security benchmark is free; adding other standards needs a paid Defender plan, and Defender for Servers Plan 1 does not count.

Say this plainly: you do not need Purview to do compliance for Azure, Arc, AWS and GCP.

Right half, organization-wide, and optional. Purview Compliance Manager pulls in the Defender for Cloud results plus Microsoft 365, and adds improvement actions and reports for auditors; usually the compliance team's tool. Cost: it comes with Microsoft 365 and Office 365 licences, but only the Microsoft Data Protection Baseline is included; E5 gets three premium standards templates free, and others buy templates as add-ons. So many of you may have it, but not in a usable form.

Along the bottom, the standards you will recognize. Be precise: these tools track and evidence controls; they do not make you compliant. A compliance score is evidence for an auditor, not a certificate. One timely note: from October 27, 2026, free Foundational CSPM is no longer on by default for new Azure subscriptions. Transition: see one of those rules evaluated and fixed on real servers.

PURPOSE

Place regulatory compliance in Govern, show what Azure does without Purview, and be honest about licensing.

Sources:
https://learn.microsoft.com/en-us/azure/defender-for-cloud/regulatory-compliance-dashboard
https://learn.microsoft.com/en-us/azure/defender-for-cloud/assign-regulatory-compliance-standards
https://learn.microsoft.com/en-us/purview/compliance-manager-regulations

## Slide 42: DEMO: evaluate and remediate Arc machines with Azure Policy — on-premises, then AWS

KEY POINTS

• On-prem cas26-arcwin01: resource ID · ops-RG assignment scope · definition · default tagValue.
• IAM: Tag Contributor at ops-RG only; absent Owner remains NonCompliant under DoNotEnforce.
• Remediate at resource scope; read Owner tag · fresh Policy state · timestamp; flag evaluation lag.
• AWS iic-cas26-prd-api-01: connector-created group · AWS-RG assignment · six-machine allowlist.
• Second assignment: ops-RG cannot reach AWS-RG; connector machines lack the Event tag.
• Run the same sequence: compliance row · remediation task · tag and Policy readback.
• Say: Azure representation’s tag changes, not native EC2; AWS lifecycle remains in AWS.
• → Next: what the Policy demo proved.

TALKING POINTS

Pass 1, on-premises. Start with the exact Arc machine resource ID for cas26-arcwin01 and the ops-RG assignment. Show the assignment scope, then the definition it references, and point out that the tagValue comes from the definition default because the assignment does not override it: assignment parameters can be silent while defaults still decide the outcome. Open the assignment identity in IAM and show Tag Contributor at that resource group only. Read the compliance row: NonCompliant because the Owner tag is absent. Say why it is still NonCompliant: the assignment runs in DoNotEnforce, so nothing corrected it on the machine's routine status writes; in Default mode the Modify effect would have tagged it on the next evaluation cycle (a write, or periodically - typically about every 24 hours). Create one remediation task at the resource scope. Read the tag back, then the fresh Policy state and its timestamp; if the evaluation has not caught up, say so and show the resource evidence instead of waiting.

Pass 2, AWS. Change only two variables: the target is the EC2 Arc machine iic-cas26-prd-api-01 in the connector-created AWS resource group, and the assignment is the AWS-RG assignment with its six-machine allowlist. Point out why a second assignment exists: the ops-RG assignment cannot reach a different resource group, and connector-created Arc machines do not carry the Event tag the first one filters on. Run the same three commands: compliance row, remediation task, readback. State the boundary clearly: this changes the Azure representation's tag, not the native EC2 tag, and AWS lifecycle stays in AWS.

Debrief. Same definition, same identity model, same evidence discipline, two hosting locations. Name what still needs an owner: the tag value proves the control works, not that a human accepted ownership. Reset between rehearsals is deleting the Owner tag; it stays deleted because the effect is not enforced on writes. Transition: what the Policy demo proved.

PURPOSE

This is the one Policy demonstration in the session. The Policy slide explained definition, assignment, effect, enforcement mode and remediation identity. Open with the subtitle: these are the same resources we onboarded earlier, and now we manage them. The AWS server on screen is the one the connector onboarded in the connector demo, and its instance ID still maps to the same Arc machine ID; onboarding was the prerequisite, this management result is the proof. This slide proves the mechanism twice with the same runbook: first on the on-premises guest, then on the AWS server, so the audience sees that one governance control reaches both hosting locations without any change to the process.

Sources:
https://learn.microsoft.com/en-us/azure/governance/policy/overview
https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources
https://learn.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure#enforcement-mode
https://learn.microsoft.com/en-us/azure/azure-arc/multicloud-connector/onboard-multicloud-vms-arc

## Slide 43: What the Policy demo proved

KEY POINTS

• What the Policy demo proved.
• One definition, two scoped assignments, two real machines: the on-premises guest and the AWS server.
• Each noncompliant resource was identified, a bounded remediation ran, and fresh Policy evidence verified the result.
• Say: same discipline everywhere: identity → scope → bounded action → fresh outcome.
• → Next: keeping every estate patched, why Azure Update Manager.

TALKING POINTS

Pause after the demo and say exactly what was proven. One definition, two scoped assignments, two real machines: the on-premises guest and the AWS server. Each noncompliant resource was identified, a bounded remediation ran, and fresh Policy evidence verified the result on both.

The line at the bottom is the discipline for everything that follows: identity, then scope, then a bounded action, then a fresh outcome. Transition: keeping every estate patched, and why Azure Update Manager.

PURPOSE

Recap what the Policy demo proved and name the discipline the rest of Govern follows.

Sources:
https://learn.microsoft.com/en-us/azure/governance/policy/overview
https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources
https://learn.microsoft.com/en-us/azure/azure-arc/system-center-virtual-machine-manager/overview

## Slide 44: Three estates, one patch process: why Azure Update Manager

KEY POINTS

• Three estates need one patch answer, not three schedules and reports.
• Ask the room: how many patch tools do you run?
• Azure: Update Manager patches VMs; Microsoft patches IIC Functions coordinator and Container Apps portal.
• On-premises: WSUS or Configuration Manager patches SCVMM guests · SQL servers · Hyper-V hosts.
• Hyper-V cluster hosts retain cluster-aware updating; AWS EC2 usually uses Systems Manager Patch Manager.
• Arc identities let Update Manager assess · schedule · report across Windows and Linux servers.
• IIC orders need on-premises and AWS workers; stagger windows and prove each with a fresh order.
• → Next: how Update Manager assesses, schedules, rings and proves patching.

TALKING POINTS

Read the top line and ask the room how many patch tools they run. Then walk the three columns. In Azure, virtual machines are native to Update Manager, and platform services such as the IIC coordinator on Functions and the portal on Container Apps are patched by Microsoft. In the on-premises private cloud, the SCVMM guests, the SQL servers and the Hyper-V hosts are usually patched with WSUS or Configuration Manager, and the cluster hosts keep cluster-aware updating. In AWS, the EC2 instances are usually patched with Systems Manager Patch Manager.

Now point to where the arrows meet. Because Arc gives every one of those servers an Azure identity, one service can assess them, schedule them and report on them: Azure Update Manager. One view answers "is everything patched?" across supported Azure VMs and Arc-enabled servers, Windows and Linux, on-premises or in another cloud.

Tie it to IIC Hybrid Orders. The order needs both workers, the one on-premises and the one in AWS, so patching is a service decision, not a server chore: plan the windows so orders keep flowing, and prove each window with a fresh order. Transition: how Update Manager actually does it.

PURPOSE

Set up the update problem before the product. Every operator in the room patches in more than one place, and the audience should recognize the pain: three estates, three tools, three schedules, three reports, three permission models, and no single answer to "is everything patched?". Then show why Arc makes one answer possible.

Sources:
https://learn.microsoft.com/en-us/azure/update-manager/overview
https://learn.microsoft.com/en-us/azure/update-manager/support-matrix

## Slide 45: How Update Manager patches every estate: assess, schedule, ring, prove

KEY POINTS

• Assess: check missing updates about every 24 hours; assign built-in Policy across Arc resource groups.
• Include the connector-created AWS group in periodic-assessment Policy scope.
• Schedule: maintenance configuration sets timing · duration · classifications · reboot permission.
• Scope by Environment and UpdateRing tags; newly onboarded matching servers join automatically.
• Ring0: dev EC2 · standalone demo guests; ring1: production web · data · SQL.
• Ring2: IIC workers, one estate per window; pre/post automation can start machines or drain work.
• Prove with Resource Graph compliance and fresh worker orders; Hyper-V clusters retain cluster-aware updating.
• → Next: servers that cannot yet be upgraded.

TALKING POINTS

Assess: periodic assessment checks every machine for missing updates about every 24 hours. Turn it on at scale with the built-in Azure Policy that configures periodic checking for Arc-enabled servers, assigned at the resource groups that hold them, including the connector-created AWS group.

Schedule: a maintenance configuration is the window. It sets when patching runs, how long it may take, which classifications install and whether the machine may reboot.

Scope by tag: a dynamic scope attaches machines to that window by filter, for example Environment and UpdateRing tags. A newly onboarded server with the right tags joins the right window automatically; nobody edits a machine list.

Roll out in rings: ring0 is the canary, the dev EC2 machines and the standalone demo guests; ring1 is production web, data and SQL after ring0 passes; ring2 is the IIC workers, one estate per window. Pre and post events can run automation before and after a window, such as starting a stopped machine or draining work.

Prove: read compliance in Resource Graph, and for the workers place a fresh order after each window. A completed patch run is evidence of the run, not recovery. Note the host exception: the Hyper-V cluster hosts are assessed and reported here, and patched with cluster-aware updating. Transition: some servers cannot be upgraded yet.

PURPOSE

Show the mechanism behind one patch process in five stages, so the audience can build it themselves: assess, schedule, scope by tag, roll out in rings, prove. The IIC ring row turns it into a service plan rather than a server list.

Sources:
https://learn.microsoft.com/en-us/azure/update-manager/scheduled-patching
https://learn.microsoft.com/en-us/azure/update-manager/dynamic-scope-overview
https://learn.microsoft.com/en-us/azure/update-manager/periodic-assessment-at-scale
https://learn.microsoft.com/en-us/azure/update-manager/pre-post-scripts-overview

## Slide 46: End of support: Extended Security Updates through Arc

KEY POINTS

• Say: hypothetical, not a customer; Windows Server Standard VM · four vCPUs · eight-core minimum.
• 2012/R2: ESUs end October 13, 2026; last month · no security updates afterward—upgrade/migrate.
• 2012/R2: $0.00648/core-hour · eight cores ~$38/month · late enrolment back-billed to ESU-term start.
• 2016: extended support ends January 12, 2027; enrol now · billing starts January 13.
• 2016: $0.007132/core-hour · eight cores ~$42/month · monthly for up to three years · stop upon upgrade.
• ESU-enrolled: Update Manager free; otherwise $5/Arc server/month · Software Assurance/equivalent subscription required.
• Say: illustrative US list prices, Azure Retail Prices API September 26; check agreement · ESUs bridge.
• → Next: see the whole update process work.

TALKING POINTS

Say first that this is a hypothetical server, not a customer: one Windows Server Standard VM with four vCPUs. ESUs through Arc are licensed by core with a minimum of eight virtual cores per VM, so it is billed as eight.

Left panel, Windows Server 2012 and 2012 R2. ESUs end on October 13, 2026; this is the last month. At the US list price of $0.00648 per core-hour, eight cores cost about $38 a month. If you enrol late, you are back-billed to the start of the ESU term. After October 13 there are no more security updates at any price, so the only answer is to upgrade or migrate.

Right panel, Windows Server 2016. Extended support ends on January 12, 2027, weeks after this conference. ESUs through Arc can be set up now and billing starts on January 13, 2027. The same eight-core VM at $0.007132 per core-hour is about $42 a month, monthly, for up to three years, and you stop paying when you upgrade.

Bottom strip: an ESU-enrolled server gets Update Manager at no extra charge; otherwise Update Manager is $5 per Arc server per month. Eligibility needs Software Assurance or an equivalent subscription. These are illustrative list prices from the Azure Retail Prices API on September 26; check your own agreement. ESUs are a bridge to an upgrade, not a destination. Transition: see the whole update process work.

PURPOSE

Deal with the servers that cannot be upgraded yet. The audience should leave knowing that Extended Security Updates can be delivered through Arc, what a typical server costs, why Windows Server 2012 is urgent and why Windows Server 2016 needs a plan now.

Sources:
https://learn.microsoft.com/en-us/windows-server/get-started/extended-security-updates-overview
https://learn.microsoft.com/en-us/lifecycle/faq/extended-security-updates
https://learn.microsoft.com/en-us/azure/azure-arc/servers/license-extended-security-updates
https://learn.microsoft.com/en-us/azure/update-manager/update-manager-faq
https://prices.azure.com/api/retail/prices

## Slide 47: DEMO: Update Manager across every estate: assess, schedule, patch, prove

KEY POINTS

• Demo: Update Manager as one process for every estate, in four steps.
• One view: pending updates for Azure, on-premises and AWS machines together.
• How machines get picked: the ring0 schedule and its tag-based scope.
• Run it: patch one on-premises and one AWS canary in the same window.
• Prove it: history, a fresh assessment, then a fresh IIC order.
• Say: a patch run proves the run; compliance and a working service prove the outcome.
• → Next: keep the Kubernetes cluster the way Git says.

TALKING POINTS

This demo is a short tour of Update Manager across every estate, in four steps.

One, one view: open Update Manager and show pending updates for Azure, on-premises and AWS machines together, one list, one query. Two, how machines get picked: open the ring0 maintenance configuration and its dynamic scope, and show that it selects machines from both estates by tag, nothing listed by hand. Three, run it: patch one on-premises and one AWS canary machine in the same window. Four, prove it: read the update history and a fresh assessment for each machine, then place a fresh IIC order to show the service still works.

The debrief: a completed patch run proves the run; fresh compliance and a working service prove the outcome. Transition: keeping the Kubernetes cluster the way Git says.

PURPOSE

Show Update Manager as one process for every estate, not just one schedule.

Sources:
https://learn.microsoft.com/en-us/azure/update-manager/query-logs
https://learn.microsoft.com/en-us/azure/update-manager/deploy-updates
https://learn.microsoft.com/en-us/azure/update-manager/dynamic-scope-overview

## Slide 48: Keep the Kubernetes cluster the way Git says (GitOps with Flux)

KEY POINTS

• Governing Kubernetes: keep the cluster the way Git says (GitOps with Flux).
• You write how the cluster should look in a Git repository.
• Arc puts Flux on the EKS cluster we onboarded earlier.
• Flux keeps the cluster matching Git and fixes drift on its own.
• Azure shows whether it matches.
• Say: AWS still owns the EKS cluster; Arc and Flux govern what runs on it.
• → Next: see it reconcile on the real cluster.

TALKING POINTS

Remember the EKS cluster from the connector demo? This is how you govern it.

The idea is called GitOps. You write down how the cluster should look, in a Git repository. Arc puts a tool called Flux on the EKS cluster. Flux keeps pulling from Git and makes the cluster match, and if someone changes something by hand, Flux puts it back. Azure shows you whether the cluster matches what Git says.

So it is the Kubernetes version of the governance question: does it stay the way we agreed? AWS still owns the EKS cluster itself; Arc and Flux govern what runs on it. Transition: let's see it reconcile on the real cluster.

PURPOSE

Explain GitOps with Flux in plain words before the demo, and tie it to governance.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/multicloud-connector/onboard-elastic-kubernetes-service-clusters-arc
https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/conceptual-gitops-flux2

## Slide 49: DEMO: manage the already-onboarded EKS cluster with Flux

KEY POINTS

• Identify EKS ARN and matching Arc resource; inspect connectivity, extension, namespace, repository access.
• Show CAS26 Flux configuration; distinguish creation now from inspecting an existing object.
• Follow source revision into reconciliation status and declared CAS26 ConfigMap content.
• Inspect Azure configuration result and ConfigMap in the intended Kubernetes namespace.
• Compare content and revision; any ConfigMap’s presence alone proves nothing.
• Show reconciliation interval and in-progress state; explain the next interval.
• Reset only runbook-defined CAS26 resources; say deleting Flux configuration is not universal rollback.
• Debrief source · declared state · observed state · bounded authority; → Next: operating costs.

TALKING POINTS

Identify the EKS cluster by ARN and confirm its matching Arc-connected cluster resource. Inspect connectivity, the required extension, the intended namespace, and repository access. Show the CAS26 Flux configuration and say whether you are creating it now or inspecting an existing one; an existing object is not a newly completed deployment.

Follow the source revision into the reconciliation status. The declared CAS26 ConfigMap gives the audience a small object whose intended content is easy to compare with the actual cluster state. Inspect both the Azure-side configuration result and the object in the intended Kubernetes namespace. Compare relevant content and revision information rather than treating the presence of any ConfigMap as success.

Discuss the reconciliation interval and asynchronous nature of the operation. If reconciliation is still in progress, show that state and explain what the next interval will change.

Reset only the CAS26-owned configuration and resources defined in the runbook. Do not imply that removing a Flux configuration automatically reverses every object it ever managed; use the specified cleanup behavior. Debrief source identity, declared state, observed state, and bounded authority. Transition to the cost of operating these capabilities.

PURPOSE

Prove cluster management live: a ConfigMap declared in Git becomes a real object in the EKS cluster through Flux. The audience should see both the Azure-side status and the in-cluster evidence, and understand that the reset is bounded.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/conceptual-gitops-flux2
https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/tutorial-use-gitops-flux2

## Slide 50: 4 · Cost: what does it cost, and how do we keep it in check?

KEY POINTS

• Section 4 of 5: Cost. The question: what does it cost, and how do we keep it in check?
• Coming up: what Arc costs · see it and control it · log transformations · the full cost of a hybrid service.
• → Next: what Arc itself costs.

TALKING POINTS

Section four of five: cost. The question is what does it cost, and how do we keep it in check? Cost is more than trimming logs: first what Arc itself costs, then how you see the cost and the five levers to control it, then log transformations, one lever in practice, and the full cost of a hybrid service. Transition: what Arc itself costs.

PURPOSE

Signal the start of the cost section and set it up as seeing and controlling cost.

## Slide 51: What Arc costs: free, paid, and free if you already own it

KEY POINTS

• Connecting to Arc is free; the services you turn on are not.
• Free: Arc itself (inventory, tags, RBAC, Resource Graph), SCVMM and VMware VM operations.
• Paid per use: Monitor data · Defender for Servers · Sentinel data · Update Manager per Arc server · machine configuration · ESUs.
• Free if you own it: Software Assurance or pay-as-you-go Windows Server → Update Manager, change tracking, machine configuration, Windows Admin Center.
• ESU-enrolled servers and Defender for Servers Plan 2 include Update Manager.
• Say: attest your Software Assurance; the discount does not apply until you do.
• → Next: how you see the cost, and how you control it.

TALKING POINTS

First question in the cost section: what does Arc actually cost? Three columns.

Free: Arc itself. Inventory, tags, role-based access and Resource Graph cost nothing, and so do the SCVMM and VMware VM operations we saw.

Paid per use: the services you turn on. Azure Monitor charges for the data you send and keep, Defender for Servers is per server, Sentinel charges for data, Update Manager is a small monthly charge per Arc server, and machine configuration, change tracking and Extended Security Updates are billed too.

The column people miss: free if you already own it. If your Windows Servers have Software Assurance, or you pay for Windows Server through Arc, you get Update Manager, change tracking, machine configuration and Windows Admin Center at no extra cost. Servers enrolled in ESUs get Update Manager free, and so do servers on Defender for Servers Plan 2. The catch: you have to attest your Software Assurance in the portal; the discount does not apply until you do. Transition: how you see the cost, and how you control it.

PURPOSE

Answer what Arc costs plainly, including the licence benefits most organizations already own but do not claim.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/overview#pricing
https://learn.microsoft.com/en-us/azure/azure-arc/servers/windows-server-management-overview
https://learn.microsoft.com/en-us/azure/update-manager/update-manager-faq#pricing

## Slide 52: See it and control it: the cost levers

KEY POINTS

• Cost has two jobs: see it, then control it.
• See: Cost Management for Microsoft cloud spend.
• Tags on every resource, enforced by Policy, so cost rolls up by service and owner.
• Budgets and anomaly alerts; AWS and on-premises bills joined by the same tags.
• Control, five levers: telemetry · licensing · commitments · right-size and clean up · guardrails.
• Say: telemetry is one lever of five; tag first.
• → Next: the telemetry lever in practice, log transformations.

TALKING POINTS

Two jobs in the operating model: see the cost, then control it.

Left, see it. Microsoft Cost Management gives you one view of Microsoft cloud spend. The key is tags on every resource, enforced with Policy, so cost rolls up by service and by owner, and you can answer "what does IIC Hybrid Orders cost?". Put budgets and anomaly alerts on top so you hear about a problem before the invoice. AWS and on-premises costs come from their own tools; joining them by the same tags gives you one picture.

Right, control it, with five levers. Telemetry: collect only what answers a question. Licensing: claim Software Assurance, Azure Hybrid Benefit, or pay as you go. Commitments: reservations and savings plans for the Azure parts. Right-size and clean up, with Azure Advisor. And guardrails: Policy that requires tags and blocks expensive choices.

Telemetry is one lever of five, and you cannot control what you cannot see, so tag first. Transition: the telemetry lever in practice, log transformations.

PURPOSE

Show the two cost jobs of an operating model, seeing and controlling, with telemetry as one of five levers.

Sources:
https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/overview-cost-management

## Slide 53: Log transformations

KEY POINTS

• Log transformations: filter data in the DCR before you pay to store it.
• A transformation is a small KQL query in the DCR that runs on every record before it is stored.
• where keeps only the rows you need; project-away drops a column nobody queries; you can also mask sensitive data.
• Learn's example: 20 GB in, 12 dropped → 8 GB billed for ingestion, 2 GB for processing.
• Table plans: Analytics (full), Basic (cheaper, troubleshooting), Auxiliary (cheapest, audit).
• The catch: dropping more than half adds a processing charge (not for Analytics tables when Sentinel is on the workspace).
• Say: decide what you keep before you pay for it.
• → Next: the full cost of a hybrid service.

TALKING POINTS

This is the telemetry lever in practice, and it ties straight back to the DCR slide in the monitoring section: the DCR decides not just what is collected but what is kept.

A transformation is a small KQL query inside the DCR, and it runs on every record before the record is stored. You pay ingestion for what is stored, so anything you filter out never reaches the bill. Two tiny examples on the slide: a where clause keeps only the rows you need, for example only errors, and project-away drops a column nobody ever queries, such as a large raw-data field. You can also mask sensitive data, such as email addresses, before it is stored.

Microsoft's own example: 20 GB comes in, the transformation drops 12, and you are billed ingestion for the 8 GB you keep. In preview, the filter can even run on the agent, so the data never leaves the server.

The second half of the lever is table plans. Each table can be Analytics, with full features; Basic, cheaper per GB, for troubleshooting data; or Auxiliary, the cheapest, for audit logs you rarely query.

The catch: if a transformation drops more than half of what comes in, you pay a small processing charge on the part beyond half; in Microsoft's example that is 2 GB. That charge does not apply to Analytics tables in a workspace with Sentinel on. Decide what you keep before you pay for it. Transition: the full cost of a hybrid service.

PURPOSE

Show a concrete, verified way to cut monitoring cost, tied back to the DCR.

Sources:
https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-transformations
https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-transformations-samples
https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs#table-plans

## Slide 54: The full cost of a hybrid service

KEY POINTS

• Hybrid cost has four parts, not just Azure charges.
• Capability and entitlement/plan · usage meter and Azure allocation.
• Source infrastructure · licenses · transfer · platform costs.
• People · tools · support · recurring operating effort.
• SCVMM or AWS capacity persists; monitoring, security, collectors, and incidents add costs.
• Tags organize allocation, not every shared bill; state allocation methods and attribution limits.
• Say: validate agreement, plan, eligibility; this model is not a current price quotation.
• Review service owner · cost owner · measurement period · adjustment; → Next: standardize recurring actions.

TALKING POINTS

Close the cost section with the full cost of a hybrid service: the Azure bill is one column; on-premises infrastructure, AWS, licences and people's time are the others.

Walk the four columns as a cost explanation an operator could take to a service owner. First name the capability and the applicable entitlement or plan. Second identify the usage meter and Azure allocation. Third add infrastructure, licenses, transfer, and platform costs in the source environment. Fourth account for people, tools, support, and recurring operating effort.

Use the same workload as the example. Its Azure representation can carry useful ownership metadata, but the VM still consumes SCVMM-hosted capacity or AWS resources. Azure monitoring and security may add their own charges, while incident handling and maintaining collectors also consume staff time. Tags help organize allocation but do not automatically apportion every shared platform bill.

Explain conditional benefits cautiously: validate the actual agreement, plan, and eligibility before including an entitlement in the business case. The slide is a cost model, not a current price quotation. For shared workspaces or services, state the allocation method and what cannot be attributed precisely.

Conclude with an accountable review: service owner, cost owner, measurement period, and next adjustment. Transition: the last section, adopting the patterns: which fixes to let the system make, and how to prove them.

PURPOSE

Widen from Azure charges to the full cost of running a hybrid service. The audience should leave with a four-part model they can take to a service owner, including the source-platform and people costs that Azure never shows.

Sources:
https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs
https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/understand-work-scopes

## Slide 55: 5 · Adopt the patterns: did the fix work, and what do we keep doing?

KEY POINTS

• Section 5 of 5: Adopt the patterns. The question: did the fix work, and what do we keep doing?
• Coming up: letting the system fix things · the playbook · what to unlearn · your first thirty days.
• → Next: letting the system fix things: how much, and how you prove it.

TALKING POINTS

Section five of five: adopt the patterns, the last of the outcomes on the agenda. The question is did the fix work, and what do we keep doing? Coming up: letting the system fix things and how you prove it, the playbook to take home, what to unlearn, and your first thirty days. Transition: letting the system fix things.

PURPOSE

Signal the last section and set it up as the take-home part of the session.

## Slide 56: Letting the system fix things: how much, and how you prove it

KEY POINTS

• Here: fixes the system makes for you (Policy remediation, scheduled patching, Flux), not CI/CD.
• Report only: a person reviews; nothing changes on its own (Policy compliance report).
• Fix with approval: the system proposes, a person approves (Policy remediation task, an approved patch ring).
• Fixes continuously: the system corrects drift on its own (Flux on the EKS cluster).
• Every level ends in the same check: verify the resource and the service.
• Failed: stop the next step, restore where possible, escalate. Passed: close it and record the evidence.
• Before the system fixes anything: owner · permissions · blast radius · when to stop · how you prove it.
• → Next: the playbook, what to adopt.

TALKING POINTS

First, what we mean here: fixes the system makes for you, like Policy remediation, scheduled patching and Flux. Not CI/CD pipelines.

There are three levels, left to right, and each one is something you already saw today. Report only: a person reviews and nothing changes on its own, like a Policy compliance report. Fix with approval: the system proposes a fix and a person approves it, like a Policy remediation task or an approved patch ring. Fixes continuously: the system corrects drift on its own, like Flux keeping the EKS cluster matching Git. How much the system may fix on its own increases left to right.

All three end in the same check: verify the resource and the service. If the check fails, stop the next step, restore where you can, and escalate. If it passes, close the change and record the evidence.

So before you let the system fix anything, name the owner, the permissions, the blast radius, when to stop, and how you will prove it worked. Transition: the playbook, what to adopt.

PURPOSE

Explain safe self-fixing in plain words, tied to the demos, without the word that makes people think of CI/CD.

Sources:
https://learn.microsoft.com/en-us/azure/governance/policy/overview
https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources
https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/conceptual-gitops-flux2

## Slide 57: The playbook: what to adopt

KEY POINTS

• The whole session in one table: one practice per section.
• Observe: one place to look; alert on the order, not the machine.
• Secure: the three key rules plus Defender coverage.
• Govern: landing zone placement, Policy with a standard, one patch process.
• Cost: tag everything, attest Software Assurance, set budgets.
• Adopt: let the system fix things only with a proof step.
• → Next: what to unlearn.

TALKING POINTS

This is the take-home table: one practice per section, in the order we covered them, with who owns it, the next action and the evidence that proves it.

Observe: one place to look, and alert on the order, not the machine. The service owner and the monitoring team build one service view and one outcome alert, and a fresh order proves it. Secure: the three key rules plus Defender coverage. The security lead checks every identity that can change a server. Govern: land resources in the designed landing zone, assign a compliance standard with Policy, and run one patch process; the governance lead and platform team own it, and the compliance dashboard and ring results prove it. Cost: tag everything, attest your Software Assurance, and set a budget per service. Adopt: let the system fix things only with a proof step; pick one fix and define how it is verified.

Transition: and what to unlearn.

PURPOSE

Give attendees one table that turns the whole session into owned next actions.

Sources:
https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-servers/eslz-management-and-monitoring-arc-server
https://learn.microsoft.com/en-us/azure/governance/policy/overview
https://learn.microsoft.com/en-us/azure/update-manager/overview
https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs

## Slide 58: And what to unlearn

KEY POINTS

• One trap per section, in section order.
• Observe: a heartbeat does not mean it works → run a fresh order.
• Secure: connected does not mean secured → check who holds which key, and Defender coverage.
• Govern: an assignment does not mean compliance → inspect evaluation and remediation.
• Cost: no bill does not mean free → find the meter, licence benefit and allocation.
• Adopt: a finished task does not mean recovery → verify the outcome.
• → Next: your first thirty days.

TALKING POINTS

Five assumptions to retire, one per section, in the order we covered them. Observe: a heartbeat does not mean the service works; run a fresh order. Secure: connected does not mean secured; check who holds which key and whether Defender covers it. Govern: assigning a policy does not mean you are compliant; look at the evaluation and the remediation. Cost: no line on the bill does not mean free; find the meter, the licence benefit and who it is allocated to. Adopt: a task that finished does not mean you recovered; verify the outcome. Transition: your first thirty days.

PURPOSE

Leave the audience with five traps to avoid, one per section.

Sources:
https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview
https://learn.microsoft.com/en-us/azure/governance/policy/how-to/get-compliance-data
https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/overview
https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs

## Slide 59: Your first thirty days

KEY POINTS

• A first month that follows the five sections.
• Week 1: inventory and owners (Govern).
• Week 2: access and the key rules (Secure), placement and Policy with a standard (Govern).
• Week 3: one service view and one outcome alert (Observe).
• Week 4: tags and budgets (Cost), one fix the system makes, proved by a fresh order (Adopt).
• Say: start with one service and repeat the pattern.
• → Next: resources and how to reach me.

TALKING POINTS

Here is a first month you can start on Monday. Week one: inventory and owners, know what you have and who owns it. Week two: access and the three key rules, then place resources in the landing zone and assign a compliance standard. Week three: one service view and one alert on the outcome. Week four: tags and budgets, and one fix the system makes for you, proved with a fresh transaction. Start with one service and repeat the pattern across the estate. Transition: resources and how to reach me.

PURPOSE

Give attendees a practical first month that follows the same five sections.

Sources:
https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-servers/landing-zone-accelerator
https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-servers/eslz-identity-and-access-management

## Slide 60: Let’s keep the conversation going

KEY POINTS

• Repository: supporting architecture · queries · runbook context; point to attendee materials and current contact information.
• Attendee notes explain slides independently; presenter edition contains delivery and demo cues.
• Say: local environment settings and credentials are not reusable attendee configuration.
• Follow up at kris@hybridsolutions.cloud with the operating question you are solving.
• → Next: complementary observability session, then conference recommendations.

TALKING POINTS

Point attendees to the repository, attendee material, and current contact information. Explain that the attendee notes are written as a standalone explanation of the slides, while the presenter edition contains delivery and demonstration cues. The repository supplies the supporting architecture, queries, and runbook context; local environment settings and credentials are not reusable attendee configuration.

Invite follow-up at kris@hybridsolutions.cloud with the operating question they are trying to solve. Transition to the complementary observability session before the conference recommendations.

PURPOSE

Point attendees to where the material lives and how to reach you, then keep moving.

## Slide 61: Whole-Service Observability

KEY POINTS

• Hybrid Operations provides the broad model: connection · identity · monitoring · protection · governance · cost · action.
• Whole-Service Observability deepens evidence correlation, dependencies, Health Models, failure investigation, and recovery verification.
• Shared IIC Hybrid Orders environment: SCVMM-hosted worker · AWS worker and portal.
• Shared baseline: resources · Policy · monitoring · Defender · Sentinel.
• Today: operate it; tomorrow: build its Health Model, break one cloud, prove a fresh order.
• Invite attendees seeking implementation detail behind the health view.
• → Next: other event recommendations.

TALKING POINTS

Explain the division between the sessions without making this session sound incomplete. Hybrid Operations supplies the broad operating model: connection, identity, monitoring evidence, protection, governance, cost, and action. Whole-Service Observability goes deeper into collecting and correlating evidence, interpreting dependencies, building and using Health Models, investigating failures, and verifying recovery.

Both sessions use the same application, IIC Hybrid Orders, and the same shared environment: the SCVMM-hosted worker, the AWS worker and portal, and the agreed resource, Policy, monitoring, Defender and Sentinel baseline. Today showed how to operate it. Tomorrow builds its Health Model, breaks one cloud on purpose and proves recovery with a fresh order.

Invite attendees who want the implementation detail behind the health view to attend the complementary session. Transition to the other event recommendations.

PURPOSE

Position the companion observability session as the deep dive behind the monitoring overview, without making this session sound incomplete.

## Slide 62: Other sessions worth attending

KEY POINTS

• Use approved recommendations; confirm session names, times, and locations against the current schedule.
• Give each recommendation a brief reason tied to the attendee’s next step.
• Say: do not invent titles, speakers, or schedule details if final information is unavailable.
• → Next: Questions.

TALKING POINTS

Use the approved conference recommendations and confirm their names, times, and locations against the current event schedule. Give a short reason each recommendation complements the attendee's next step rather than reading an entire programme. Do not invent a session title, speaker, or schedule detail when the final event information is unavailable.

Keep the closing sequence brief and move to the final Questions slide.

PURPOSE

Recommend a few other sessions briefly and move to Questions.

## Slide 63: Questions?

KEY POINTS

• Open Q&A; keep this slide up for the whole of it; the thank-you slide comes only at the close.
• Repeat each question so the room and the recording hear it.
• Say: for environment-specific questions, the answer depends on current configuration, licensing, support matrix and permissions.
• If a question needs a proper look, point to the contact slide and follow up; do not guess.

TALKING POINTS

Open the floor. Keep this slide up for the whole Q&A; the thank-you slide follows only when you close. Repeat each question before you answer it.

When a question is about someone's own environment, separate the pattern from the specifics: the specifics depend on their current configuration, licensing, the support matrix and permissions. If it needs a proper look, point them to the contact details and follow up rather than guess.

PURPOSE

Hold the Q&A. The slide carries no prompt of its own.

## Slide 64: Thank you — feedback & resources

KEY POINTS

• Thank attendees; ask them to scan the visible Hybrid Operations QR code.
• Invite feedback: were connection · monitoring · security · governance · cost · automation actionable?
• Public repository: storyboard · attendee materials · demos · runbooks · handouts · lab documentation · references.
• Say: private credentials and environment-specific configuration are intentionally excluded.
• Attendee notes explain every slide independently; nobody needed to take notes.
• For a specific runbook, name its demo and the repository demo folder.
• Leave time for scans; close with the follow-up contact shown earlier.

TALKING POINTS

Thank attendees and ask them to scan the Hybrid Operations QR code while it is visible. Invite feedback on whether the session made connection, monitoring, security, governance, cost and automation decisions understandable and actionable. Point to the public repository and name the resources: storyboard, attendee materials, demos, runbooks, handouts, lab documentation and references. State that private credentials and environment-specific configuration are intentionally excluded. Leave enough time for scans and close with the follow-up contact already shown earlier. Remind the room that the attendee notes explain every slide on their own, so nobody needed to take notes during the session. If someone asks for a specific runbook, name the demo it belongs to so they can find it in the repository's demo folder.

PURPOSE

Close the session. Collect feedback while the QR code is on screen, and point attendees to the public resources that let them use the material after the event.

