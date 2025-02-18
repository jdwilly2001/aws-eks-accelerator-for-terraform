variable "helm_config" {
  type        = any
  description = "Helm provider config for Yunikorn"
  default     = {}
}

variable "eks_cluster_id" {
  type        = string
  description = "EKS Cluster Id"
}

variable "manage_via_gitops" {
  type        = bool
  default     = false
  description = "Determines if the add-on should be managed via GitOps"
}

variable "tags" {
  type        = map(string)
  description = "Common Tags for AWS resources"
  default     = {}
}

variable "irsa_policies" {
  type        = list(string)
  default     = []
  description = "IAM Policy ARN list for any IRSA policies"
}

variable "irsa_permissions_boundary" {
  type        = string
  default     = ""
  description = "IAM Policy ARN for IRSA IAM role permissions boundary"
}