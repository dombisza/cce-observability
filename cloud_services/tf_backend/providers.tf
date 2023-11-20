provider "opentelekomcloud" {
  auth_url       = "https://iam.${var.region}.otc.t-systems.com/v3"
  domain_name    = var.domain_name
  tenant_name    = var.region
  security_token = var.ak_sk_security_token
}
