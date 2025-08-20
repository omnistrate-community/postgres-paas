# Helm-based PostgreSQL Deployment

This directory contains a Helm chart-based implementation for deploying PostgreSQL using Bitnami's PostgreSQL chart with Omnistrate.

## 🏗️ Architecture

- **Chart**: Bitnami PostgreSQL v16.7.26
- **Primary/Replica**: Configurable read replicas
- **Storage**: Persistent volumes with encryption
- **Networking**: Dual endpoints for read/write separation

## ⚙️ Configuration Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `username` | String | `postgres` | PostgreSQL master username |
| `password` | Password | - | PostgreSQL master password (required) |
| `instanceType` | String | `t3.medium` | Kubernetes node instance type |
| `storageSize` | String | `20Gi` | Persistent volume size |
| `readReplicaCount` | Float64 | `0` | Number of read replicas |

## 🚀 Features

- ✅ **Dual Endpoints**: Separate writer and reader endpoints
- ✅ **Read Replicas**: Configurable horizontal read scaling
- ✅ **Persistent Storage**: Configurable storage with encryption
- ✅ **Load Balancing**: External load balancers with DNS
- ✅ **Resource Management**: CPU and memory limits/requests
- ✅ **High Availability**: Anti-affinity and node distribution

## 📁 File Structure

```
helm/
├── spec.yaml           # Omnistrate service specification
└── README.md          # This file
```

## 🔧 Key Components

### Helm Chart Configuration
- **Chart Source**: Bitnami PostgreSQL from official repository
- **Primary Instance**: Single writer instance with full PostgreSQL features
- **Read Replicas**: Scalable read-only instances for query load distribution
- **Services**: LoadBalancer services with external DNS integration

### Endpoint Configuration
- **Writer Endpoint**: `$sys.network.externalClusterEndpoint`
- **Reader Endpoint**: `reader-{{ $sys.network.externalClusterEndpoint }}`

## 🔄 Automated Operations

### Day-1 Operations
- Cluster initialization and bootstrap
- Database and user creation
- Service endpoint configuration
- Storage provisioning

### Day-2 Operations
- **Scaling**: Horizontal and vertical scaling APIs
- **Updates**: Rolling PostgreSQL version updates

## 🔒 Security Features

- Pod security contexts and non-root execution
- Network policies and service mesh integration
- Kubernetes secrets for credential management
- Encrypted persistent volumes
- Node affinity for secure placement

## 📈 Scaling Guide

### Vertical Scaling
- Modify `instanceType` parameter
- Increase `storageSize` for more storage

### Horizontal Scaling
- Increase `readReplicaCount` for read workloads
- Reader endpoint automatically load balances across replicas

## 📚 References

- [Bitnami PostgreSQL Chart Documentation](https://github.com/bitnami/charts/tree/main/bitnami/postgresql)
- [Helm Documentation](https://helm.sh/docs/)
- [PostgreSQL High Availability](https://www.postgresql.org/docs/current/high-availability.html)
