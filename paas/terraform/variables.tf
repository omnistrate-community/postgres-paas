variable "postgres_version" {
  description = "PostgreSQL version for Aurora cluster"
  type        = string
  default     = "15.4"
}

variable "master_username" {
  description = "Master username for the Aurora cluster"
  type        = string
  default     = "{{ $var.username }}"
}

variable "master_password" {
  description = "Master password for the Aurora cluster"
  type        = string
  default     = "{{ $var.password }}"
  sensitive   = true
}

variable "instance_class" {
  description = "Instance class for Aurora cluster instances"
  type        = string
  default     = "{{ $var.instanceType }}"
}

variable "read_replica_count" {
  description = "Number of read replicas to create"
  type        = number
  default     = {{ $var.readReplicaCount }}
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "{{ $sys.deploymentCell.region }}"
}
