# CloudNativePG Operator PostgreSQL Deployment

This directory contains the Omnistrate operator-based PostgreSQL service plan. The plan follows the current Omnistrate operator pattern: install operator charts through `operatorCRDConfiguration.helmChartDependencies`, then model the tenant resource lifecycle with `systemWorkflows` that apply, patch, and delete Kubernetes custom resources.

The main service plan is [`byoa-spec.yaml`](byoa-spec.yaml). It deploys CloudNativePG (CNPG), the Barman Cloud plugin, a CNPG `Cluster`, S3-backed backup resources, public writer and reader endpoints, and snapshot restore workflows.

## Files

```
operator/
├── byoa-spec.yaml      # Omnistrate BYOA service plan using CNPG systemWorkflows
├── crd.yaml            # CNPG CRD reference material
└── README.md           # This guide
```

## Service Plan Structure

The operator-backed service is defined in one Omnistrate service named `CNPG`:

- `compute.instanceTypes` maps the `instanceType` API parameter to AWS node placement.
- `apiParameters` exposes customer inputs for PostgreSQL credentials, database name, instance count, storage, and S3 backup configuration.
- `endpointConfiguration` publishes a primary writer endpoint and a secondary reader endpoint.
- `operatorCRDConfiguration.helmChartDependencies` installs the `cloudnative-pg` and `plugin-barman-cloud` Helm charts.
- `capabilities.backupConfiguration` enables periodic backups, retention, and snapshot-before-delete.
- `systemWorkflows` implements create, modify, start, stop, delete, backup, restore, and delete-backup lifecycle operations.

This spec intentionally omits the older operator fields `operatorCRDConfiguration.template`, `operatorCRDConfiguration.supplementalFiles`, `operatorCRDConfiguration.readinessConditions`, and `operatorCRDConfiguration.outputParameters`. Kubernetes manifests, readiness checks, and output values now live inside `systemWorkflows`.

## Configuration Parameters

| Parameter | Type | Default | Modifiable | Description |
| --- | --- | --- | --- | --- |
| `instanceType` | String | `t3.medium` | Yes | Kubernetes node instance type |
| `postgresqlPassword` | Password | - | No | PostgreSQL application password |
| `postgresqlUsername` | String | `app` | No | PostgreSQL application username |
| `postgresqlDatabase` | String | `app` | No | Initial database name |
| `numberOfInstances` | Float64 | `1` | Yes | CNPG instance count, minimum 1 |
| `storageSize` | String | `20Gi` | Yes | Data volume size per instance |
| `backupS3BucketName` | String | - | Yes | S3 bucket used by Barman Cloud backups |
| `backupS3BucketRegion` | String | - | Yes | AWS region for the backup bucket |
| `backupS3AccessKeyId` | String | - | Yes | Access key ID for backup storage |
| `backupS3SecretAccessKey` | Password | - | Yes | Secret access key for backup storage |

## Operator Installation

Operator installation is declared under `operatorCRDConfiguration.helmChartDependencies`:

```yaml
operatorCRDConfiguration:
  helmChartDependencies:
    - chartName: cloudnative-pg
      chartVersion: 0.28.2
      chartRepoName: cnpg
      chartRepoURL: https://cloudnative-pg.github.io/charts
    - chartName: plugin-barman-cloud
      chartVersion: 0.6.0
      chartRepoName: cnpg
      chartRepoURL: https://cloudnative-pg.github.io/charts
```

Use this plan-spec dependency pattern when the deployment cell is tied to this PostgreSQL service lifecycle. If many tenant databases share the same Kubernetes cluster-level operator, install the operator as a deployment-cell amenity instead and keep the tenant CR lifecycle in the service plan.

## System Workflows

The service lifecycle is implemented with Argo Workflow-style `systemWorkflows`. Each workflow passes Omnistrate system values such as `$sys.namespace`, `$sys.instanceId`, `$sys.network.externalClusterEndpoint`, `$sys.deploymentCell.region`, and customer values from `$var.*` into Kubernetes `resource` templates.

| Workflow | Purpose |
| --- | --- |
| `create` | Creates PostgreSQL credentials, S3 credentials, a Barman Cloud `ObjectStore`, and the CNPG `Cluster`. |
| `modify` | Reapplies the CNPG `Cluster` with updated modifiable inputs such as instance count, storage size, endpoints, and placement metadata. |
| `start` | Patches the CNPG hibernation annotation to `off`. |
| `stop` | Patches the CNPG hibernation annotation to `on`. |
| `delete` | Deletes the CNPG `Cluster`, PostgreSQL secret, Barman Cloud `ObjectStore`, and S3 secret. |
| `backup` | Rehydrates the cluster if needed, creates a CNPG `Backup`, and returns backup metadata to Omnistrate. |
| `restore` | Creates a new target CNPG `Cluster` from an Omnistrate snapshot and the captured backup metadata. |
| `deleteBackup` | Deletes the CNPG `Backup` resource for explicit snapshot deletion or retention cleanup. |

The required lifecycle hooks for an operator-backed plan are `create`, `modify`, and `delete`. The additional workflows in this plan expose a complete database lifecycle through Omnistrate APIs, the Customer Portal, Operations Center, and CLI.

## Readiness and Outputs

Readiness is no longer declared with top-level `operatorCRDConfiguration.readinessConditions`. Resource templates define `successCondition` and `failureCondition` next to the manifest they manage.

For the CNPG cluster, create and modify wait for the operator to report the expected instance count:

```yaml
successCondition: status.instances == {{inputs.parameters.numberOfInstances}}, status.readyInstances == {{inputs.parameters.numberOfInstances}}
failureCondition: status.phase == failed
```

Workflow outputs are declared under each workflow's `outputParameters`. The create and modify workflows expose:

| Output | Source |
| --- | --- |
| `postgresContainerImage` | `$tasks.applycluster.resource.status.image` |
| `status` | `$tasks.applycluster.resource.status.phase` |
| `topology` | `$tasks.applycluster.resource.status.topology` |

The backup workflow returns `backupId` and `backupName` from the CNPG `Backup` status so the restore workflow can locate the selected snapshot data.

## Backup and Restore

Backups are enabled with:

```yaml
capabilities:
  backupConfiguration:
    backupRetentionInDays: 1
    backupPeriodInHours: 1
    snapshotBeforeDeletion: true
```

The `backup` workflow receives Omnistrate snapshot context (`$sys.snapshot.id` and `$sys.snapshot.time`), ensures the cluster is awake, creates a CNPG `Backup`, and returns CNPG backup metadata.

The `restore` workflow receives restore context from `$sys.restore.*`, source and target instance IDs, and the original S3 configuration. It creates restore-specific `ObjectStore` resources, then creates a new CNPG `Cluster` using `bootstrap.recovery`.

## Endpoints

The service exposes two public PostgreSQL endpoints:

| Endpoint | Host | Port | Purpose |
| --- | --- | --- | --- |
| `writer` | `$sys.network.externalClusterEndpoint` | `5432` | Primary read-write PostgreSQL traffic |
| `reader` | `reader-{{ $sys.network.externalClusterEndpoint }}` | `5432` | Read-only PostgreSQL traffic |

The CNPG `Cluster` manifest creates matching load-balanced Kubernetes services through CNPG managed service templates.

## Build and Validate

Build the service plan with `omnistrate-ctl`:

```bash
omnistrate-ctl build -f operator/byoa-spec.yaml --spec-type ServicePlanSpec
```

After creating a test instance, validate:

- The CNPG and Barman Cloud Helm dependencies are installed.
- The tenant namespace contains the PostgreSQL secret, S3 secret, `ObjectStore`, and CNPG `Cluster`.
- The CNPG `Cluster` status contains the fields referenced by `successCondition` and workflow `outputParameters`.
- The Customer Portal shows the writer and reader endpoints.
- Manual backup and restore succeed before relying on scheduled backups.

## References

- [Omnistrate operator spec template](https://github.com/omnistrate-community/operator-spec-template)
- [Omnistrate build from Kubernetes operators](https://docs.omnistrate.com/getting-started/build-from-operators/)
- [CloudNativePG documentation](https://cloudnative-pg.io/)
- [CNPG Barman Cloud plugin](https://cloudnative-pg.io/plugin-barman-cloud/)
