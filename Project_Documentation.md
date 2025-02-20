# Project Documentation: AWS EKS with Terraform and ArgoCD CI/CD

## Overview
This project sets up an **Amazon EKS** (Elastic Kubernetes Service) cluster using **Terraform** and automates application deployment using **ArgoCD**. Two separate **Git repositories** are used to maintain infrastructure and application configurations:
1. **Terraform Repository (`nayax`)** - Manages EKS cluster creation.
2. **ArgoCD Repository (`nayax_argocd`)** - Manages application deployment across Dev, Stage, and Prod environments.

## Infrastructure Setup
- **Terraform** provisions an EKS cluster in **`eu-west-1`**.
- Uses IAM roles for cluster and node permissions.
- Creates Kubernetes namespaces: **dev, stage, prod**.
- Stores infrastructure as code in **`nayax`** repository.
- Includes **scaling configuration** for node groups to ensure resource availability.

## CI/CD Pipeline Setup
The pipeline consists of two workflows:

### **1. Terraform CI/CD Workflow** (Infrastructure Setup)
Located in the `nayax` repository, this pipeline:
- Runs on **push** and **pull requests** to `main`.
- **Initializes, validates, plans, and applies** Terraform changes.
- Uses **GitHub Secrets** to manage AWS credentials securely.
- Includes a **security scan** with `tflint`.

#### Steps:
1. **Checkout Terraform Repository**
2. **Setup Terraform**
3. **Configure AWS Credentials** (via GitHub Secrets)
4. **Initialize Terraform**
5. **Validate Terraform Code**
6. **Plan Terraform Execution**
7. **Apply Terraform Changes** *(only on `main` branch)*
8. **Run Security Scan** (Terraform Validation & Linting)

### **2. ArgoCD Deployment Workflow** (Application Deployment)
Located in the `nayax_argocd` repository, this pipeline:
- Runs on **push** to `main`.
- Deploys application updates across **Dev, Stage, and Prod** using ArgoCD.
- Ensures **progressive deployment** from **Dev > Stage > Prod**.

#### Steps:
1. **Checkout ArgoCD Repository**
2. **Install ArgoCD CLI**
3. **Sync Application Deployment to Dev**
4. **Sync Application Deployment to Stage**
5. **Sync Application Deployment to Prod**

## Security Considerations
- **GitHub Secrets**: Store AWS access credentials securely.
- **Role-based Access**: Uses IAM roles to limit permissions.
- **State Management**: Terraform state should be stored securely (e.g., in an S3 bucket with DynamoDB for locking).

## How to Use the Pipeline
### **1. Deploy Infrastructure with Terraform**
- Push changes to `nayax` repository.
- The GitHub Actions pipeline will automatically create/update the EKS cluster.

### **2. Deploy Application with ArgoCD**
- Push application changes to `nayax_argocd` repository.
- The GitHub Actions pipeline will sync the application to **Dev**, then **Stage**, and finally **Prod** .