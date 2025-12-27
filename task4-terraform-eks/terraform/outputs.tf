output "ecr_repo_url" {
  value = aws_ecr_repository.app.repository_url
}

output "cluster_name" {
  value = aws_eks_cluster.this.name
}

