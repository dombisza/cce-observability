resource "opentelekomcloud_identity_role_v3" "this_obs" {
  description   = "loki role to allow obs access"
  provider        = opentelekomcloud.top_level_project
  display_name  = "${var.prefix}-loki_role_obs-${var.region}"
  display_layer = "domain"
  statement {
    effect = "Allow"
    resource = [
      "OBS:*:*:bucket:${opentelekomcloud_obs_bucket.this.id}",
      "OBS:*:*:object:*"
    ]
    action = [
      "obs:object:DeleteObject",
      "obs:object:PutObject",
      "obs:object:GetObject",
      "obs:bucket:ListBucket",
      "obs:bucket:GetEncryptionConfiguration"
    ]
  }
}

resource "opentelekomcloud_identity_role_v3" "this_kms" {
  description   = "loki role to allow kms access"
  display_name  = "${var.prefix}-loki_role_kms-${var.region}"
  provider        = opentelekomcloud.top_level_project
  display_layer = "project"

  statement {
    effect = "Allow"
    action = [
      "kms:cmk:list",
      "kms:cmk:get",
    ]
  }
  statement {
    effect = "Allow"
    resource = [
      "KMS:*:*:KeyId:${opentelekomcloud_kms_key_v1.this.id}"
    ]
    action = [
      "kms:cmk:generate",
      "kms:dek:create",
      "kms:cmk:crypto",
      "kms:dek:crypto",
    ]
  }

}
resource "opentelekomcloud_identity_user_v3" "this" {
  provider        = opentelekomcloud.top_level_project
  name        = "${var.prefix}-${var.loki_user}-${var.region}"
  description = var.loki_user_desc
  access_type = "programmatic"

  lifecycle {
    ignore_changes = [pwd_reset]
  }
}

resource "opentelekomcloud_identity_credential_v3" "this" {
  provider        = opentelekomcloud.top_level_project
  user_id     = opentelekomcloud_identity_user_v3.this.id
  description = "created by terraform"
}

resource "opentelekomcloud_identity_group_v3" "this" {
  provider        = opentelekomcloud.top_level_project
  name        = "${var.prefix}-${var.loki_user}-${var.region}"
  description = var.loki_user_desc
}

resource "opentelekomcloud_identity_role_assignment_v3" "this" {
  provider        = opentelekomcloud.top_level_project
  group_id     = opentelekomcloud_identity_group_v3.this.id
  domain_id    = var.domain_id
  role_id      = opentelekomcloud_identity_role_v3.this_obs.id
  all_projects = true
}

resource "opentelekomcloud_identity_role_assignment_v3" "this_kms" {
  provider        = opentelekomcloud.top_level_project
  group_id     = opentelekomcloud_identity_group_v3.this.id
  domain_id    = var.domain_id
  role_id      = opentelekomcloud_identity_role_v3.this_kms.id
  all_projects = true
}


resource "opentelekomcloud_identity_user_group_membership_v3" "this" {
  provider        = opentelekomcloud.top_level_project
  user   = opentelekomcloud_identity_user_v3.this.id
  groups = [opentelekomcloud_identity_group_v3.this.id]
}
