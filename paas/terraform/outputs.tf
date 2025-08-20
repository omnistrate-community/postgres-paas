output "cluster_endpoint" {
  description = "Aurora cluster endpoint"
  value       = aws_rds_cluster.aurora_postgres.endpoint
}

output "cluster_reader_endpoint" {
  description = "Aurora cluster reader endpoint"
  value       = aws_rds_cluster.aurora_postgres.reader_endpoint
}

output "cluster_port" {
  description = "Aurora cluster port"
  value       = aws_rds_cluster.aurora_postgres.port
}

output "cluster_id" {
  description = "Aurora cluster ID"
  value       = aws_rds_cluster.aurora_postgres.cluster_identifier
}

output "cluster_arn" {
  description = "Aurora cluster ARN"
  value       = aws_rds_cluster.aurora_postgres.arn
}

output "master_username" {
  description = "Aurora cluster master username"
  value       = aws_rds_cluster.aurora_postgres.master_username
}

output "master_password" {
  description = "Aurora cluster master password"
  value       = aws_rds_cluster.aurora_postgres.master_password
  sensitive   = true
}

output "database_name" {
  description = "Aurora cluster database name"
  value       = aws_rds_cluster.aurora_postgres.database_name
}

output "writer_instance_endpoint" {
  description = "Writer instance endpoint"
  value       = aws_rds_cluster_instance.aurora_postgres_writer.endpoint
}

output "reader_instance_endpoints" {
  description = "Reader instance endpoints"
  value       = aws_rds_cluster_instance.aurora_postgres_readers[*].endpoint
}
