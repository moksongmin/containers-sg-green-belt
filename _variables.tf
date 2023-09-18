variable "region" {
  default = "eu-west-2"
}

variable "tags" {
  default = {}
}
variable "account_id" {
  description = "AWS Account ID"
  type        = string
  default     = null
}