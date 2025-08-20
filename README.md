# PostgreSQL Deployment Options with Omnistrate

This repository demonstrates four different approaches to deploying PostgreSQL clusters using Omnistrate's service orchestration platform. Each approach offers different levels of control, management overhead, and use cases.

## 🚀 Deployment Options Overview

| Approach | Technology | Management |
|----------|------------|------------|
| **Native** | Kubernetes YAML | Omnistrate-managed |
| **Helm** | Helm Charts | DR-managed |
| **Operator** | CNPG Operator | Operator-managed |
| **PaaS** | AWS RDS Aurora | Cloud-provider-managed |

## 📁 Directory Structure

```
├── native/          # Kubernetes YAML manifests
├── helm/            # Bitnami PostgreSQL Helm chart
├── operator/        # CloudNativePG (CNPG) operator
├── paas/           # AWS RDS Aurora with Terraform
└── README.md       # This file
```

## 🔄 Common Features Across All Approaches

All four approaches provide:

- **Configurable Parameters**: Username, password, instance types, storage
- **Multiple Endpoints**: Separate writer and reader endpoints
- **Omnistrate Integration**: System variables, deployment cells, networking
- **Security**: Encryption at rest, network security groups
- **Monitoring**: Integration with Omnistrate's observability stack
- **Scaling**: Horizontal (read replicas) and vertical (instance size) scaling

## 🚀 Getting Started

1. **Choose your approach** based on your requirements
2. **Navigate to the respective directory** for detailed instructions
3. **Review the `spec.yaml`** file for configuration options
4. **Deploy using the Omnistrate** platform

## 📖 Further Reading

- [Omnistrate Documentation](https://docs.omnistrate.com)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [CloudNativePG Documentation](https://cloudnative-pg.io/)
- [AWS RDS Aurora Documentation](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/)

---

*Each directory contains its own README with specific implementation details and deployment instructions.*
