# AWS RDS Aurora PostgreSQL Deployment

This directory contains a Platform-as-a-Service (PaaS) implementation using AWS RDS Aurora PostgreSQL with Terraform and Omnistrate.

## 🏗️ Architecture

- **Database Engine**: Aurora PostgreSQL 15.4
- **Infrastructure**: Terraform-managed AWS resources
- **High Availability**: Multi-AZ Aurora cluster with automatic failover
- **Scaling**: Aurora Serverless and read replica scaling
- **Backup**: Automated backup and point-in-time recovery

## ⚙️ Configuration Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `username` | String | `postgres` | Master username for Aurora cluster |
| `password` | Password | - | Master password (required) |
| `instanceType` | String | `db.r6g.large` | Aurora instance class |
| `readReplicaCount` | Float64 | `1` | Number of Aurora read replicas |

## 🚀 Features

- ✅ **Fully Managed**: Zero operational overhead for database management
- ✅ **High Availability**: Multi-AZ deployment with automatic failover
- ✅ **Auto Scaling**: Aurora Serverless and automatic read replica scaling
- ✅ **Backup & Recovery**: Automated backups with point-in-time recovery
- ✅ **Performance**: Aurora performance optimizations and caching
- ✅ **Security**: Encryption at rest and in transit, VPC isolation

## 📁 File Structure

```
paas/
├── terraform/
│   ├── main.tf         # Aurora cluster and infrastructure
│   ├── variables.tf    # Terraform variables
│   └── outputs.tf      # Resource outputs and endpoints
├── spec.yaml           # Omnistrate service specification
└── README.md          # This file
```

## 🔧 Key Components

### Terraform Infrastructure (`terraform/`)

#### Aurora Cluster (`main.tf`)
- **Aurora Cluster**: PostgreSQL-compatible Aurora cluster
- **Security Groups**: Network security for Aurora access
- **Subnet Groups**: Multi-AZ subnet configuration
- **Cluster Instances**: Writer and configurable read replicas

#### Variables (`variables.tf`)
- Terraform variables mapped to Omnistrate API parameters
- Support for all configurable cluster options

#### Outputs (`outputs.tf`)
- Cluster endpoints (writer and reader)
- Connection details and cluster metadata
- Exported password for application access

### Service Specification (`spec.yaml`)
- Terraform integration with git-based source
- Endpoint configuration for writer/reader separation
- Required outputs mapping for external access

## 🔄 Automated Operations

### AWS-Managed Operations
- **Backup Management**: Automated daily backups with configurable retention
- **Patch Management**: Automatic security and feature updates
- **Failover**: Automatic primary instance failover (< 30 seconds)
- **Scaling**: Automatic storage scaling and read replica management
- **Monitoring**: Built-in performance and health monitoring

### Omnistrate-Managed Infrastructure
- **Resource Provisioning**: Automated Aurora cluster creation
- **Configuration Management**: Infrastructure-as-code best practices
- **Version Control**: Git-based infrastructure change tracking
- **Validation**: Terraform plan and apply validation

## 📈 Scaling Guide

### Read Scaling
- **Read Replicas**: Increase `readReplicaCount` for read workload distribution
- **Aurora Serverless**: Consider serverless for variable workloads
- **Global Database**: Implement Aurora Global Database for global read scaling

### Write Scaling
- **Instance Sizing**: Increase `instanceType` for write performance
- **Aurora Parallel Query**: Leverage for analytical workloads
- **Connection Pooling**: Implement application-level connection pooling

## 📚 References

- [AWS RDS Aurora Documentation](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/)
- [Aurora PostgreSQL Features](https://aws.amazon.com/rds/aurora/postgresql-features/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Aurora Best Practices](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.BestPractices.html)
