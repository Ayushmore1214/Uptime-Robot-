module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name    = var.cluster_name
  cluster_version = "1.28"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  eks_managed_node_groups = {
    spot_nodes = {
      name           = "spot-node-group"
      instance_types = ["t3.micro", "t2.micro"]
      capacity_type  = "SPOT"
      min_size       = 1
      max_size       = 3
      desired_size   = 2
    }
  }
}

# Allow RDS traffic from EKS nodes
resource "aws_security_group_rule" "allow_rds_from_eks" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = module.eks.node_security_group_id
}

resource "aws_ecr_repository" "main" {
  name = "k-stax-repo"
}

