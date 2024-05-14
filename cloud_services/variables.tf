variable "domain_name" {}

variable "prefix" {
  type    = string
  default = "logging"
}

variable "ak_sk_security_token" {
  type        = string
  description = "Security Token for temporary AK/SK"
}

variable "region" {
  type    = string
}

variable "loki_user" {
  type    = string
  default = "loki2obs"
}

variable "loki_user_desc" {
  type    = string
  default = "Loki RBAC for logging stack, managed by terraform"
}

variable "domain_id" {
  type = string
}

variable "s3_chunks" {
  type        = string
  description = "OBS bucket for storing loki indexes and log chunks"
}

variable "index_expiration" {
  type        = number
  description = "Expiration time of indexes in OBS"
  default     = 365
}

variable "GRAFANA_DOMAIN" {
  type = string
  description = "export TF_VAR_GRAFANA_DOMAIN='grafana domain'"
}

variable "GRAFANA_FQDN" {
  type = string
  description = "export TF_VAR_GRAFANA_FQDN='grafana fqdn'"
}
