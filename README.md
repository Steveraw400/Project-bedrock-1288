# Project Bedrock — InnovateMart Retail Store App on AWS EKS

This project deploys a production-style microservices application (**retail-store-sample-app**) to **Amazon EKS** using **Terraform** for infrastructure and **Helm** for application deployment. It also implements secure, least-privilege developer access and event-driven serverless processing.

> ✅ **Core Requirements Completed**
- VPC + EKS (private node networking, public endpoint enabled for exam access)
- Namespace-based deployment (`retail-app`)
- Secure developer access (`bedrock-dev-view`) with:
  - AWS Console ReadOnlyAccess
  - Kubernetes read-only access (can `get`, cannot `delete`)
- Observability: EKS control plane logging + application/container logs to CloudWatch
- Event-driven extension: S3 → Lambda trigger logs uploaded filename to CloudWatch
- CI/CD automation using GitHub Actions (PR = plan, main = apply)


## Architecture (High-Level)
- **AWS Networking:** VPC with public + private subnets, NAT gateway (single)
- **Compute:** Amazon EKS cluster (`project-bedrock-cluster`) with managed node group
- **App:** retail-store-sample-app deployed via Helm into `retail-app`
- **Observability:** CloudWatch (EKS control plane logs + container logs)
- **Serverless:** S3 bucket `bedrock-assets-1288` triggers Lambda `bedrock-asset-processor`
- **Developer Access:** IAM user `bedrock-dev-view` (read-only console + kubectl view permissions)

---

## Prerequisites

### Local tools
- Terraform
- AWS CLI
- kubectl
- Helm
- Git

### AWS access
- An AWS account with permissions to create:
  - VPC, EKS, IAM, KMS, S3, Lambda, CloudWatch, DynamoDB (backend locking)
- Region: `us-east-1`

---

## Repository Structure (example)

.github/workflows/
terraform.yml
deployment-app.yml
terraform/
backend.tf
locals.tf
vpc.tf
eks.tf
iam.tf
s3.tf
lambda.tf
observability.tf
outputs.tf
k8s/
ui-ingress.yaml






