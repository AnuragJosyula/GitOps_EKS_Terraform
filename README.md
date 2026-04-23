# GitOps AWS EKS Terraform Deployment

This repository contains the Infrastructure as Code (IaC) to automatically provision a production-ready AWS EKS cluster and configure a GitOps workflow using ArgoCD.

## 🏗️ Architecture

The infrastructure is provisioned using **Terraform** and includes:
- **VPC** with Public and Private subnets spanning across 3 Availability Zones.
- **NAT Gateway** for outbound internet access from private subnets.
- **AWS EKS Cluster** (`gitops-eks-cluster`) deployed in private subnets.
- **EKS Managed Node Group** running `t3.medium` instances.
- **EBS CSI Driver** Addon configured with IAM Roles for Service Accounts (IRSA).
- **ArgoCD** deployed into the `argocd` namespace and exposed via an AWS Classic LoadBalancer.

## 🔄 GitOps Separation of Concerns

This project follows the GitOps best practice of strictly separating Infrastructure code from Application manifests:

1. **Infrastructure Repository** (This Repo): Responsible solely for provisioning AWS infrastructure and the initial ArgoCD bootstrap.
2. **Application Repository** ([GitOPS_application](https://github.com/AnuragJosyula/GitOPS_application)): Responsible solely for the Kubernetes manifests (Deployments, Services, Kustomizations). 

ArgoCD runs inside the EKS cluster and continuously monitors the **Application Repository**. Whenever a developer pushes changes to the application manifests, ArgoCD automatically syncs and applies those changes to the cluster.

## 🚀 Deployment Instructions

### Prerequisites
- AWS CLI configured with appropriate credentials.
- Terraform CLI (>= 1.5.0) installed.
- `kubectl` installed.

### 1. Initialize and Apply
Ensure you are in the `terraform/` directory:
```bash
cd terraform
terraform init
terraform apply -auto-approve
```
*Note: The cluster provisioning takes approximately 15 minutes.*

### 2. Connect to the Cluster
Once Terraform completes, update your local kubeconfig:
```bash
aws eks update-kubeconfig --region us-east-1 --name gitops-eks-cluster
```

### 3. Access ArgoCD UI
ArgoCD is exposed via a LoadBalancer. Get the URL:
```bash
kubectl get svc argocd-server -n argocd -o wide
```

Retrieve the initial admin password:
```powershell
# On Windows PowerShell
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | ForEach-Object { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }

# On Linux/Mac
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
Log in using the username `admin` and the decrypted password.

## 🔒 Security Best Practices

To ensure maximum security of your AWS environment, the following measures are in place:
1. **Private EKS Nodes**: EKS worker nodes are placed entirely in private subnets, completely inaccessible from the public internet directly.
2. **IAM Roles for Service Accounts (IRSA)**: The EBS CSI driver operates using least-privilege IAM roles mapped to Kubernetes ServiceAccounts, avoiding the need to attach broad EC2 instance profiles.
3. **S3 Backend**: Terraform state is stored securely in an S3 bucket (`dante-bucket-tfstate`) rather than locally.
4. **Git Ignore Protections**: This repository explicitly ignores `.terraform/`, `*.tfstate`, `*.tfplan`, and `*.tfvars` files to ensure sensitive AWS access keys, tokens, or infrastructure state are **never** accidentally pushed to GitHub.


