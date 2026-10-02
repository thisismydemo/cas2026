# EKS / Arc / Flux companion

Live route: slide 49, H26 (after slide 48: AWS still owns the EKS cluster; Arc and Flux govern what runs on it). Use the shared [Kustomization](../../../../../sessions/hybrid-operations-2026/demos/src/sample-service/kubernetes/kustomization.yaml) and [manifest](../../../../../sessions/hybrid-operations-2026/demos/src/sample-service/kubernetes/demo-configmap.yaml); do not fork them here.

The manifest creates `cas26-demo` and the `cas26-operating-contract` ConfigMap. Expected data includes `owner: hybrid-operations`, `change-boundary: dedicated-demo-namespace` and `expected-state: reconciled-by-azure-arc-flux`. This demonstrates desired-state management, not application health or EKS lifecycle management.

Before running this against your own cluster, map EKS ARN→Arc `Microsoft.Kubernetes/connectedClusters` resource→exact kubectl context. Check that the Git repository/branch includes `sessions/hybrid-operations-2026/demos/src/sample-service/kubernetes`, and verify API access, the Connected Arc agents on `eks-iic-cas26-use2-01` and the `microsoft.flux` extension. Private repositories need separately configured credentials; never paste a token into the console.

Show the actual reconciled revision/status and ConfigMap content in the same cluster. A created Azure configuration alone does not prove reconciliation. If showing drift, change only the rehearsed CAS26 ConfigMap data key and observe Flux restore it.

**Reset:** Configuration deletion with `prune=true` can remove managed objects, including the namespace declared here. Review all namespaced resource kinds and ownership, not just `kubectl get all`, before post-event removal. If unrelated objects exist, stop cleanup and consult the lab operator. Never delete shared Flux extensions, the EKS cluster or its Arc connection to reset this demo.

Sources: [Flux tutorial](https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/tutorial-use-gitops-flux2), [EKS onboarding](https://learn.microsoft.com/en-us/azure/azure-arc/multicloud-connector/onboard-elastic-kubernetes-service-clusters-arc).
