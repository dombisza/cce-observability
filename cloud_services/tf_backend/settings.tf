terraform {
  required_version = "<=1.5.5,>=v1.4.6"
  required_providers {
    opentelekomcloud = {
      source  = "opentelekomcloud/opentelekomcloud"
      version = ">=1.35.6"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }
  }
}
