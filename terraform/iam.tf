module "iam_oidc_provider" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-oidc-provider"
  version = "5.30.0"

  tags = {
    Name = "github-oidc-provider"
  }
}

data "aws_iam_policy_document" "github_oidc_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [module.iam_oidc_provider.arn]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_repo}:*"]
    }
  }
}

resource "aws_iam_role" "github_oidc_role" {
  name               = "github-oidc-role"
  assume_role_policy = data.aws_iam_policy_document.github_oidc_assume_role_policy.json
}

# Attach policies your pipeline needs
resource "aws_iam_role_policy_attachment" "ecr_power_user" {
  role       = aws_iam_role.github_oidc_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_role_policy_attachment" "s3_full_access" {
  role       = aws_iam_role.github_oidc_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess" # Be more specific in production
}

resource "aws_iam_role_policy_attachment" "eks_cluster_access" {
  role       = aws_iam_role.github_oidc_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
