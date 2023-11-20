provider "opentelekomcloud" {
  auth_url       = "https://iam.${var.region}.otc.t-systems.com/v3"
  security_token = var.ak_sk_security_token
}

provider "opentelekomcloud" {
  auth_url       = "https://iam.${var.region}.otc.t-systems.com/v3"
  domain_name    = var.domain_name
  tenant_name    = var.region
  alias          = "top_level_project"
  security_token = var.ak_sk_security_token
}
