# CloudNativePG Operator PostgreSQL Deployment

This directory contains a CloudNativePG (CNPG) operator-based implementation for deploying production-grade PostgreSQL clusters with Omnistrate.

## 🏗️ Architecture

- **Operator**: CloudNativePG v0.26.0
- **Cluster Management**: Automated PostgreSQL cluster lifecycle
- **Storage**: Resizable GP3 volumes with automatic management
- **High Availability**: Built-in failover and replica management

## ⚙️ Configuration Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `postgresqlUsername` | String | `app` | PostgreSQL application username |
| `postgresqlPassword` | Password | - | PostgreSQL password (required) |
| `postgresqlDatabase` | String | `app` | Default database name |
| `instanceType` | String | `t3.medium` | Kubernetes node instance type |
| `numberOfInstances` | Float64 | `1` | Total cluster instances (min: 1) |
| `storageSize` | String | `20Gi` | Storage size per instance |

## 🚀 Features

- ✅ **Automated Operations**: Backup, recovery, failover, and scaling
- ✅ **High Availability**: Multi-instance clusters with automatic failover
- ✅ **Dual Endpoints**: Separate read-write and read-only services
- ✅ **Storage Management**: Automatic volume resizing and management
- ✅ **Monitoring**: Built-in metrics and health monitoring
- ✅ **Rolling Updates**: Zero-downtime PostgreSQL updates

## 📁 File Structure

```
operator/
├── spec.yaml           # Omnistrate service specification with CNPG CRD
└── README.md          # This file
```

## 🔧 Key Components

### CloudNativePG Cluster CRD
- **Bootstrap Configuration**: Automated database and user creation
- **Storage Management**: GP3 storage with resize capabilities
- **Service Management**: Automatic read-write and read-only service creation
- **Security**: Kubernetes-native secret management

### Endpoint Configuration
- **Writer Endpoint**: `$sys.network.externalClusterEndpoint`
- **Reader Endpoint**: `reader-{{ $sys.network.externalClusterEndpoint }}`

### Readiness Conditions
- **Health Check**: `"$var._crd.status.phase": "Cluster in healthy state"`
- **Ready Status**: `'$var._crd.status.conditions[?(@.type=="Ready")].status': "True"`

## 📊 Monitoring & Observability

### Built-in Features
- **Health Monitoring**: Cluster health and readiness tracking
- **Metrics Export**: Prometheus-compatible metrics
- **Status Reporting**: Real-time cluster status and topology
- **Event Logging**: Detailed operational event logging

### Output Parameters
- **Container Image**: `$var._crd.status.image`
- **Status**: `$var._crd.status.phase`
- **Topology**: `$var._crd.status.topology`

## 🔄 Automated Operations

### Day-1 Operations
- Cluster initialization and bootstrap
- Database and user creation
- Service endpoint configuration
- Storage provisioning

### Day-2 Operations
- **Backup Management**: Automated backup scheduling
- **Failover**: Automatic primary instance failover
- **Scaling**: Horizontal and vertical scaling
- **Updates**: Rolling PostgreSQL version updates
- **Monitoring**: Continuous health and performance monitoring

## 📈 Scaling Guide

### Horizontal Scaling
- Increase `numberOfInstances` for read replicas
- Automatic load balancing across instances
- Built-in failover and leader election

### Vertical Scaling
- Modify `instanceType` for compute scaling
- Increase `storageSize` for storage scaling
- Automatic volume resizing without downtime

## 📚 References

- [CloudNativePG Documentation](https://cloudnative-pg.io/)
- [PostgreSQL High Availability](https://www.postgresql.org/docs/current/high-availability.html)
- [Kubernetes Operators](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/)
- [CNPG GitHub Repository](https://github.com/cloudnative-pg/cloudnative-pg)
