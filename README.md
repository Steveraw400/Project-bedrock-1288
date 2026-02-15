# Project Bedrock – InnovateMart EKS Deployment

**Barakat Third Semester Exam – AltSchool Africa Cloud DevOps**

This repository contains the complete infrastructure and deployment code for **Project Bedrock**, a production-grade Amazon EKS environment for the AWS Retail Store Sample Application.

### Project Overview

- **Company**: InnovateMart Inc.
- **Mission**: Provision secure EKS cluster + deploy Retail Store Sample App + serverless image processing extension
- **AWS Region**: us-east-1 (N. Virginia)
- **Core Components**:
  - VPC with public/private subnets (2 AZs)
  - Amazon EKS cluster (`project-bedrock-cluster`)
  - Retail Store Sample App in namespace `retail-app` (via Helm chart)
  - Observability: CloudWatch Logs (control plane + container logs)
  - Serverless: S3 bucket + Lambda trigger for asset processing
  - Secure developer access: IAM user `bedrock-dev-view` (ReadOnly + Kubernetes view RBAC)
  - CI/CD: GitHub Actions (terraform plan on PR, apply on merge)

**Important**: This project follows strict naming conventions and tagging required for automated grading.

### Architecture Summary

- VPC (`project-bedrock-vpc`) → EKS cluster in private subnets
- EKS → Helm-deployed microservices + in-cluster databases
- Public access to app: via port-forward (core requirement only – no ALB/Ingress bonus)
- Event-driven: S3 uploads → Lambda → CloudWatch Logs
- All resources tagged: `Project: barakat-2025-capstone`

See `architecture-diagram.png` (or draw.io link) in the repo for visual.

### Repository Structure
* terraform/                  # IaC – VPC, EKS, S3, Lambda, add-ons
 -main.tf
 -provider.tf
 -outputs.tf
 -backend.tf
 -variables.tf

lambda/                     # Lambda function code
  -index.py
  -kubernetes/                 # Helm values (if customized)
  values-retail.yaml      # optional overrides
.github/workflows/          # CI/CD pipeline
   -terraform.yml
   -grading.json                # Terraform outputs for grading script
   -README.md


### Prerequisites

- AWS account with permissions for EKS, VPC, S3, Lambda, IAM, CloudWatch
- Terraform >= 1.9
- AWS CLI configured (`aws configure`)
- kubectl
- Helm 3+

### Quick Start (Local Deployment)

1. Clone repo
   ```bash

   git clone https://github.com/Steveraw400/project-bedrock-1288.git
   cd project-bedrock-1288/terraform

### Initialize Terraform (remote state in S3 + DynamoDB)Bashterraform init -upgrade
1.Plan & Apply 

terraform plan
terraform apply --auto-approve

Update kubeconfig
aws eks update-kubeconfig --name project-bedrock-cluster --region us-east-1

Deploy Retail Store App
kubectl create namespace retail-app
helm install retail-store oci://public.ecr.aws/aws-containers/retail-store-sample-chart \
  --namespace retail-app --wait --timeout 15m
  
### Access the app Externally 
http://k8s-retailap-retailst-d2956870a1-186988286.us-east-1.elb.amazonaws.com/home

See Deployment Guide below for full CI/CD and verification steps.
CI/CD Pipeline
GitHub Actions workflow:

On pull request → terraform plan
On push to main → terraform apply

See .github/workflows/terraform.yml for details.
Important Files for Grading

### grading.json → generated via terraform output -json > grading.json
Access credentials for bedrock-dev-view → stored securely in submission document


```markdown
# Deployment Guide – Project Bedrock

## 1. How to Trigger the CI/CD Pipeline

This project uses **GitHub Actions** for automated Terraform execution.

**Workflow file**: `.github/workflows/terraform.yaml,deployment-app.yaml`

**Triggers & Steps**:

- **Pull Request** (to main branch)
  - Runs `terraform plan`
  - Shows proposed changes
  - Requires approval to merge

- **Push / Merge to main**
  - Runs `terraform apply --auto-approve`
  - Automatically applies changes to AWS

**Authentication**:
- Uses **Access ID and secret access key** with AWS IAM role (no long-lived access keys in repo)
- Role assumes via GitHub Actions AWS integration

**To trigger**:
1. Make changes (e.g., update variables, add resources)
2. Commit & push to a feature branch
3. Open Pull Request → review plan output
4. Merge PR → infrastructure updates automatically

3. Grading Credentials
IAM User: bedrock-dev-view
AWS Console: ReadOnlyAccess policy attached
Kubernetes: Mapped to view-only RBAC (AmazonEKSViewPolicy via access entry)
Can: kubectl get pods -n retail-app
Cannot: kubectl delete pod ...

## Credentials (provided in submission Google Doc):

Access Key ID:     AKIAXXXXXXXXXXXXXXXX
Secret Access Key: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

Test commands (using temporary AWS profile):
aws configure --profile bedrock-dev-view
# Enter above keys + region us-east-1

aws eks update-kubeconfig --name project-bedrock-cluster --region us-east-1 --profile bedrock-dev-view

kubectl get pods -n retail-app
# Should succeed

kubectl delete pod dummy-pod -n retail-app --force --grace-period=0
# Should fail: forbidden
4. Verification Checklist (for grader / self-check)


### Troubleshooting
“State lock” issues

If a run is interrupted, state lock may remain. Check the DynamoDB table for lock entry.
If you must unlock:

terraform force-unlock <LOCK_ID>

## All resources tagged Project: barakat-2025-capstone
 EKS cluster: project-bedrock-cluster running in us-east-1
 Retail Store pods healthy in retail-app namespace
 S3 bucket bedrock-assets-1288 triggers Lambda on upload
 Lambda logs "Image received: ..." in CloudWatch
 Control plane logs enabled in CloudWatch
 Container logs flowing via amazon-cloudwatch-observability add-on
 grading.json committed in repo root
 Developer IAM user + RBAC view access verified






