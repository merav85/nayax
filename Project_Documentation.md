# Project Documentation: AWS EKS CI/CD Pipeline

## Overview
This project automates the deployment of a Kubernetes-based application using AWS EKS, Terraform, GitHub Actions, and ArgoCD.

## Components - Git Repos
- **nayax/**: Terraform scripts to provision an AWS EKS cluster.
- **nayax_argocd/**: Kubernetes manifests and ArgoCD configurations.

## Deployment Steps
1. Deploy the infrastructure using Terraform.
2. Push Kubernetes manifests to the `argocd-repo`.
3. GitHub Actions will automatically trigger the deployment.
4. Monitor the deployment using ArgoCD.

## Best Practices
- Use GitHub Secrets for sensitive data.
- Maintain Terraform state remotely.
- Implement RBAC for Kubernetes security.

# Project Documentation: AWS EKS CI/CD Pipeline

## Overview
This project automates the deployment of a Kubernetes-based application using AWS EKS, Terraform, GitHub Actions, and ArgoCD. The system supports multiple environments (Dev, Stage, Prod) as separate Kubernetes namespaces.

## Components
- Infrastructure Repository (terraform-repo): Contains Terraform scripts to provision an AWS EKS cluster.
- ArgoCD Repository (argocd-repo): Hosts Kubernetes manifests and ArgoCD configurations for deploying applications across Dev, Stage, and Prod.

## CI/CD Pipeline 

## Overview
The GitHub Actions pipeline consists of three main jobs:
1. Provision EKS Cluster (Terraform)
    - Runs Terraform to create/update the EKS cluster.
    - Uses OpenID Connect (OIDC) for authentication (no credentials in SCM).
2. Deploy to EKS (ArgoCD)
    -Updates Kubernetes manifests stored in the argocd-repo.
    -ArgoCD syncs the deployment to the EKS cluster.
3. Run Security & Availability Tests
    - Ensures application is running and accessible.
    - Runs security scans on Kubernetes resources.

## How to Use the Pipeline

## Prerequisites
- AWS account with IAM role permissions.
- GitHub repository secrets configured:
    * AWS_ROLE_ARN: IAM role for OIDC authentication.
    * ECR_REPO: Amazon ECR repository URL.

## Deployment Steps
1. Setup Terraform State
    - Navigate to terraform-repo/
    - Run:
        * terraform init
        * terraform apply -auto-approve     
2. Push Kubernetes Manifests
    - Navigate to argocd-repo/
    - Commit and push changes to the main branch.
3. CI/CD Execution
    - GitHub Actions triggers automatically.
    - The pipeline provisions infrastructure and deploys applications via ArgoCD.
    - Runs automated tests for security and availability.
4. Monitor Deployment
    - Use ArgoCD UI or CLI to track deployment status:
        * kubectl get pods -n dev  # Check application status in Dev environment
        * Verify test results in GitHub Actions logs.

## Best Practices
    - Use GitHub Secrets to store sensitive data.
    - Maintain Terraform state remotely (S3 + DynamoDB).
    - Implement role-based access control (RBAC) for Kubernetes security.

## Troubleshooting
    - Terraform Errors: Ensure AWS IAM permissions are correctly configured.
    - Pipeline Fails at Deployment: Check ArgoCD logs and sync status.
    - Application Not Accessible: Verify Kubernetes service and ingress configurations.
    - Test Failures: Check logs for security vulnerabilities or downtime alerts.

## Future Improvements
    - Implement monitoring with Prometheus & Grafana.
    - Add automated rollback for failed deployments.    