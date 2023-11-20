resource "random_id" "this" {
  byte_length = 4
}

resource "opentelekomcloud_kms_key_v1" "this" {
  provider        = opentelekomcloud.top_level_project
  key_alias       = "${var.prefix}-loki-kms-encryption-${random_id.this.hex}-${var.region}"
  pending_days    = "7"
  key_description = "KMS key for loki chunks bucket"
  realm           = var.region
  is_enabled      = true

}

resource "opentelekomcloud_obs_bucket" "this" {
  # bucket name will not be prefixed, because it is set directly by the user
  provider        = opentelekomcloud.top_level_project
  bucket        = var.s3_chunks
  acl           = "private"
  force_destroy = true
  region        = var.region
  server_side_encryption {
    algorithm  = "kms"
    kms_key_id = opentelekomcloud_kms_key_v1.this.id
  }
  lifecycle_rule {
    name    = "index"
    prefix  = "index/"
    enabled = true

    expiration {
      days = var.index_expiration
    }
  }
}
