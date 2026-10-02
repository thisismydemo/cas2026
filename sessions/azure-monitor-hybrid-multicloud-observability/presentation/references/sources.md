# Observability primary references

Reviewed September 26, 2026. Preview and pricing statements must be rechecked before delivery.

- Azure Monitor Health Models overview: https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/overview
- Health modeling and customer commitments: https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/health-modeling
- Health Model concepts: https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/concepts
- Health Models CLI preview: https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/cli
- Azure Monitor Agent overview: https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview
- Data collection rules: https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview
- Logs ingestion API: https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview
- Azure Monitor workbooks: https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/workbooks-overview
- Azure Monitor alerts: https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview
- Log Analytics cost and usage: https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs
- OpenTelemetry traces: https://opentelemetry.io/docs/concepts/signals/traces/
- SCOM Health Explorer (monitor rollup): https://learn.microsoft.com/en-us/system-center/scom/manage-consoles-overview-healthexplorer?view=sc-om-2025
- SCOM distributed applications: https://learn.microsoft.com/en-us/system-center/scom/manage-using-authoring-workspace?view=sc-om-2025#distributed-applications
- Multicloud connector enabled by Azure Arc overview: https://learn.microsoft.com/en-us/azure/azure-arc/multicloud-connector/overview
- Multicloud inventory: https://learn.microsoft.com/en-us/azure/azure-arc/multicloud-connector/view-multicloud-inventory
- Arc onboarding for Amazon EKS through the multicloud connector (preview): https://learn.microsoft.com/en-us/azure/azure-arc/multicloud-connector/onboard-elastic-kubernetes-service-clusters-arc
- Health Model rollup, dependency rules and impact settings: https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/rollup
- Azure Arc-enabled servers overview: https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview
- Flexera 2026 State of the Cloud Report (released March 18, 2026; 73% hybrid, 88% multicloud): https://www.flexera.com/about-us/press-center/cloud-entwickelt-sich-vom-kostenfaktor-zum-werttreiber

Implementation evidence: the application design of record is `../../../../lab/design/HYBRID-APPLICATION-HEALTH-DESIGN.md`; demo commands, queries and fixtures are in `../../demos/`. CorrelationId correlation in CAS26 is not presented as distributed tracing: the stage records share an ID, but no spans or trace context are implemented.
