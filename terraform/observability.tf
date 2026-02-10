
# 1) Install EKS Pod Identity Agent add-on
resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name = module.eks.cluster_name
  addon_name   = "eks-pod-identity-agent"

  depends_on = [module.eks]
}

# 2) IAM role for CloudWatch Observability addon (Pod Identity trust)

data "aws_iam_policy_document" "cw_obs_trust" {
  statement {
    sid     = "AllowEksAuthToAssumeRoleForPodIdentity"
    effect  = "Allow"
    actions = ["sts:AssumeRole", "sts:TagSession"]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cw_observability_role" {
  name               = "bedrock-cw-observability-role"
  assume_role_policy = data.aws_iam_policy_document.cw_obs_trust.json
  tags               = local.tags
}

# Required permissions for the addon
resource "aws_iam_role_policy_attachment" "cw_agent_policy" {
  role       = aws_iam_role.cw_observability_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}


# 3) Pod Identity association for the addon service account
# CloudWatch Observability addon typically uses:
# namespace: amazon-cloudwatch
# service account: cloudwatch-agent

resource "aws_eks_pod_identity_association" "cw_obs_assoc" {
  cluster_name    = module.eks.cluster_name
  namespace       = "amazon-cloudwatch"
  service_account = "cloudwatch-agent"
  role_arn        = aws_iam_role.cw_observability_role.arn

  depends_on = [
    aws_eks_addon.pod_identity_agent,
    module.eks
  ]
}

# 4) Install the CloudWatch Observability EKS Add-on

resource "aws_eks_addon" "cloudwatch_observability" {
  cluster_name = module.eks.cluster_name
  addon_name   = "amazon-cloudwatch-observability"

  depends_on = [
    aws_eks_pod_identity_association.cw_obs_assoc
  ]
}
