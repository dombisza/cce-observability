# This file has been generated from ./tf_backend/main.tf:null_resource
terraform {
  required_version = "<=1.5.5, >=v1.4.6"
  backend "s3" {
    endpoint                    = "obs.eu-de.otc.t-systems.com"
    bucket                      = "sdombi-loki-stack-tfstate-93b927e7"
    kms_key_id                  = "44d5e318-0e54-4550-9444-0cb0aa89017d" 
    key                         = "loki-stack/tfstate-cloud-service"
    skip_region_validation      = true
    skip_credentials_validation = true
    region                      = "eu-de"
    encrypt = true
   }
   required_providers {
     opentelekomcloud = {
     source  = "opentelekomcloud/opentelekomcloud"
     version = ">=1.35.6"
     }
   }
}
