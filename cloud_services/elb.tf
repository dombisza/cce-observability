variable "elb_name" {
  type    = string
  default = "cce-grafana-elb"
}

variable "elb_flavor" {
  type    = string
  default = "L7_flavor.elb.s1.small" # "l7_flavor.elb.shared"
}

variable "availability_zones" {
  type    = list(string)
  default = ["eu-de-01"]
}

variable "subnet_name" {
  type        = string
  default     = ""
  description = "export TF_VAR_subnet_name='mysubnet'"
}

# original annotation to setup an OTC ELB on the fly
# kubernetes.io/elb.autocreate: '{"type":"public","bandwidth_name":"cce-grafana","bandwidth_chargemode":"traffic","bandwidth_size":5,"bandwidth_sharetype":"PER","eip_type":"5_mailbgp"}'

data "opentelekomcloud_lb_flavor_v3" "elb_L7_flavor" {
  name = var.elb_flavor
}

data "opentelekomcloud_vpc_subnet_v1" "subnet_v1" {
  name = var.subnet_name
}

resource "opentelekomcloud_vpc_eip_v1" "elb_eip" {
  bandwidth {
    charge_mode = "traffic"
    name        = "cce-grafana-eip-bandwidth"
    share_type  = "PER"
    size        = 5
  }
  publicip {
    type = "5_bgp"
  }
}

resource "opentelekomcloud_lb_loadbalancer_v3" "elb" {
  name               = var.elb_name
  router_id          = data.opentelekomcloud_vpc_subnet_v1.subnet_v1.vpc_id
  #network_ids        = [var.network_id]
  network_ids        = [data.opentelekomcloud_vpc_subnet_v1.subnet_v1.id]
  #subnet_id          = data.opentelekomcloud_vpc_subnet_v1.subnet_v1.id
  availability_zones = var.availability_zones
  l7_flavor          = data.opentelekomcloud_lb_flavor_v3.elb_L7_flavor.id
  public_ip {
    id = opentelekomcloud_vpc_eip_v1.elb_eip.id
  }
}

output "elb_id" {
  value = opentelekomcloud_lb_loadbalancer_v3.elb.id
}

output "elb_eip" {
  value = opentelekomcloud_vpc_eip_v1.elb_eip.publicip[0].ip_address
}

