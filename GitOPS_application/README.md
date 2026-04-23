# GitOPS_application

Kubernetes manifests for the 3-tier web application, managed by ArgoCD.

## Structure

```
3tier-configs/
├── kustomization.yaml   # Kustomize orchestration
├── namespace.yaml       # Application namespace
├── secret.yaml          # Database credentials
├── postgres.yaml        # PostgreSQL deployment, PVC & service
├── backend.yaml         # Backend deployment, configmap & service
└── frontend.yaml        # Frontend deployment, configmap & service
```

## How It Works

ArgoCD watches this repository and automatically syncs the Kubernetes manifests to the EKS cluster. Any changes pushed here will be automatically applied to the cluster via GitOps.

## Related

- **Infrastructure (Terraform):** [GitOps_EKS_Terraform](https://github.com/AnuragJosyula/GitOps_EKS_Terraform)
