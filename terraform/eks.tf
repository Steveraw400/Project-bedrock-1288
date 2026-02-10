module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "project-bedrock-cluster"
  cluster_version = "1.34"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

  cluster_enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  enable_irsa = true

  eks_managed_node_groups = {
    default = {
      min_size       = 2
      max_size       = 4
      desired_size   = 2
      instance_types = ["t3.medium"]

      tags = local.tags
    }
  }

  tags                                     = local.tags
  enable_cluster_creator_admin_permissions = true

  # ✅ CRITICAL FIX
  # Force KMS admin to the Terraform-created user
  kms_key_administrators = [
    aws_iam_user.bedrock_dev.arn
  ]

  # ✅ EKS access via module (NO duplicates elsewhere)
  access_entries = {
    bedrock-dev-view = {
      principal_arn = aws_iam_user.bedrock_dev.arn

      policy_associations = {
        read_only = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"

          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  depends_on = [aws_iam_user.bedrock_dev]
}
