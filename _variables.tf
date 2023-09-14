variable "region" {
  default = "eu-west-2"
}

variable "tags" {
  default = {}
}

### Logging module variables
# variable "fluentbit_cluster_info_configs" {
#   description = "FluentBit major configuration settings"
#   type        = map(string)
#   default = {
#     "logs.region"  = "us-east-1",
#     "cluster.name" = "swo-onboarding",
#     "http.server"  = "On",
#     "http.port"    = "2020",
#     "read.head"    = "Off",
#     "read.tail"    = "On"
#   }
# }

# variable "fluentbit_image" {
#   description = "FluentBit image which will be used for the DaemonSet deployment"
#   type        = string
#   default     = null
# }

# variable "namespace_name" {
#   description = "Name of the namespace where the fluent-bit will be deployed"
#   type        = string
#   default     = "amazon-cloudwatch"
# }

# variable "logs_destination_store" {
#   description = "Destination where the EKS application/dataplane/host logs will be forwarded by FluentBit. Possible options are `cloudwatch`, `s3` or `both` of them. Default is `cloudwatch`"
#   type        = string
#   default     = "both"
# }

# variable "existing_s3_bucket_name" {
#   description = "Name of an existing S3 Bucket which will be used. If you use this S3 bucket must be created out side of this code and all the security consideration must be in place (for example encryption and so on). If this variable is not specified current code will create S3, KMS keys for them and will add the needed permissions"
#   type        = string
#   default     = null
# }

# variable "create_s3_kms" {
#   description = "Determine if the KMS keys will be created in the solution or module will create them on his own"
#   type        = bool
#   default     = true
# }

# variable "prefix_name" {
#   description = "Prefix Name which will be used resource creation"
#   type        = string
#   default     = "fluent-bit"
# }

variable "account_id" {
  description = "AWS Account ID"
  type        = string
  default     = null
}