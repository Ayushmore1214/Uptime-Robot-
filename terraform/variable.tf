variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "k-stax-cluster"
}

variable "db_password" {
  description = "Password for the RDS database. Must be at least 8 characters."
  type        = string
  sensitive   = true
}

variable "github_repo" {
  description = "Your GitHub repository in 'owner/repo' format."
  type        = string
  # Example: "johndoe/k-stax-project"
}
