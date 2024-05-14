data "opentelekomcloud_dns_zone_v2" "app_zone" {
  name = "${var.GRAFANA_DOMAIN}."
}

resource "opentelekomcloud_dns_recordset_v2" "app_fqdn" {
  zone_id     = data.opentelekomcloud_dns_zone_v2.app_zone.id
  name        = "${var.GRAFANA_FQDN}."
  description = "CCE Grafana access FQDN"
  ttl         = 300
  type        = "A"
  records     = [opentelekomcloud_vpc_eip_v1.elb_eip.publicip[0].ip_address]
}

output "zone_id" {
  value = data.opentelekomcloud_dns_zone_v2.app_zone.id
}

