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

variable "domain_id" {
  type = string
}
