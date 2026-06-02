provider "aws" {
  region = "{{ $sys.deploymentCell.region }}"
}

locals {
  cluster_id = "aurora-cluster-08-{{ $sys.id }}"
}

resource "aws_rds_cluster" "aurora" {
  cluster_identifier = local.cluster_id
  engine             = "aurora-postgresql"
  database_name      = "appdb08"
  master_username    = "postgres"
  master_password    = "temporary-password-08"
  skip_final_snapshot = true
}

output "cluster_id" {
  value = aws_rds_cluster.aurora.cluster_identifier
}

output "cluster_endpoint" {
  value = aws_rds_cluster.aurora.endpoint
}

output "cluster_reader_endpoint" {
  value = aws_rds_cluster.aurora.reader_endpoint
}
