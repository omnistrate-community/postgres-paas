provider "aws" {
  region = "{{ $sys.deploymentCell.region }}"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

# Create a Security Group for Aurora
resource "aws_security_group" "aurora_sg" {
  name        = "postgres-aurora-sg-{{ $sys.id }}"
  description = "Security group for Aurora PostgreSQL cluster"
  vpc_id      = "{{ $sys.deploymentCell.cloudProviderNetworkID }}"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Adjust for appropriate security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "postgres-aurora-sg-{{ $sys.id }}"
  }
}

# Create a DB Subnet Group for Aurora
resource "aws_db_subnet_group" "aurora_subnet_group" {
  name        = "postgres-aurora-subnet-group-{{ $sys.id }}"
  description = "Subnet group for Aurora PostgreSQL cluster"

  subnet_ids = [
    "{{ $sys.deploymentCell.publicSubnetIDs[0].id }}",
    "{{ $sys.deploymentCell.publicSubnetIDs[1].id }}",
    "{{ $sys.deploymentCell.publicSubnetIDs[2].id }}"
  ]

  tags = {
    Name = "postgres-aurora-subnet-group-{{ $sys.id }}"
  }
}

# Generate random password for master user
resource "random_password" "master_password" {
  length  = 16
  special = true
}

# Aurora PostgreSQL Cluster
resource "aws_rds_cluster" "aurora_postgres" {
  cluster_identifier      = "postgres-aurora-cluster-{{ $sys.id }}"
  engine                 = "aurora-postgresql"
  engine_version         = var.postgres_version
  database_name          = "postgres"
  master_username        = var.master_username
  master_password        = var.master_password != "" ? var.master_password : random_password.master_password.result
  backup_retention_period = 7
  preferred_backup_window = "07:00-09:00"
  preferred_maintenance_window = "sun:05:00-sun:07:00"
  
  vpc_security_group_ids = [aws_security_group.aurora_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.aurora_subnet_group.name
  
  storage_encrypted = true
  skip_final_snapshot = true
  
  tags = {
    Name = "postgres-aurora-cluster-{{ $sys.id }}"
  }
}

# Aurora PostgreSQL Cluster Instances
resource "aws_rds_cluster_instance" "aurora_postgres_writer" {
  identifier           = "postgres-aurora-writer-{{ $sys.id }}"
  cluster_identifier   = aws_rds_cluster.aurora_postgres.id
  instance_class       = var.instance_class
  engine              = aws_rds_cluster.aurora_postgres.engine
  engine_version      = aws_rds_cluster.aurora_postgres.engine_version
  publicly_accessible = true
  
  tags = {
    Name = "postgres-aurora-writer-{{ $sys.id }}"
    Role = "writer"
  }
}

# Aurora PostgreSQL Read Replicas
resource "aws_rds_cluster_instance" "aurora_postgres_readers" {
  count                = var.read_replica_count
  identifier           = "postgres-aurora-reader-${count.index}-{{ $sys.id }}"
  cluster_identifier   = aws_rds_cluster.aurora_postgres.id
  instance_class       = var.instance_class
  engine              = aws_rds_cluster.aurora_postgres.engine
  engine_version      = aws_rds_cluster.aurora_postgres.engine_version
  publicly_accessible = true
  
  tags = {
    Name = "postgres-aurora-reader-${count.index}-{{ $sys.id }}"
    Role = "reader"
  }
}
