resource "random_id" "id" {
  byte_length = 4
}

locals {
  bucket_name = "${var.prefix}-loki-stack-tfstate-${random_id.id.hex}"
}

resource "opentelekomcloud_kms_key_v1" "this" {
  key_alias       = "${var.prefix}-loki-stack-tfbackend-${random_id.id.hex}"
  pending_days    = "7"
  key_description = "KMS key for loki-stack tfstate bucket encryption"
  realm           = var.region
  is_enabled      = true

}

resource "opentelekomcloud_obs_bucket" "backend" {
  bucket        = local.bucket_name
  acl           = "private"
  versioning    = true
  force_destroy = true
  server_side_encryption {
    algorithm  = "kms"
    kms_key_id = opentelekomcloud_kms_key_v1.this.id
  }
}

resource "null_resource" "generate_settings" {
  triggers = {
    always_run = "${timestamp()}"
  }
  depends_on = [opentelekomcloud_obs_bucket.backend]

  provisioner "local-exec" {
    command = <<EOT
      cat > ../settings.tf <<END
# This file has been generated from ./tf_backend/main.tf:null_resource
terraform {
  required_version = "<=1.5.5, >=v1.4.6"
  backend "s3" {
    endpoint                    = "obs.${var.region}.otc.t-systems.com"
    bucket                      = "${opentelekomcloud_obs_bucket.backend.bucket}"
    kms_key_id                  = "${opentelekomcloud_kms_key_v1.this.id}" 
    key                         = "loki-stack/tfstate-cloud-service"
    skip_region_validation      = true
    skip_credentials_validation = true
    region                      = "${var.region}"
    encrypt = true
   }
   required_providers {
     opentelekomcloud = {
     source  = "opentelekomcloud/opentelekomcloud"
     version = ">=1.35.6"
     }
   }
}
END
    EOT
  }
}
