output "eks_cluster_endpoint" {
  description = "Endpoint for the EKS cluster."
  value       = module.eks.cluster_endpoint
}

output "rds_endpoint" {
  description = "The endpoint of the RDS instance."
  value       = aws_db_instance.main.endpoint
}

output "frontend_url" {
  description = "The URL of the deployed frontend."
  value       = "https://${aws_cloudfront_distribution.s3_distribution.domain_name}"
}

output "frontend_bucket_name" {
  description = "The name of the S3 bucket for the frontend."
  value       = aws_s3_bucket.frontend_bucket.id
}

output "ecr_repo_url" {
  description = "The URL of the ECR repository for the backend image."
  value       = aws_ecr_repository.main.repository_url
}
