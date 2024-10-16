module "vm" {
  source        = "../simple_vm"
  name          = "${var.year}-ephemeral"
  ports         = [22, 80, 443, 8448]
  instance_type = "m1.medium"
  network       = "general_servers2"
  disk_size     = 30
  dns_zone      = var.dns_zone
}

resource "aws_route53_record" "dns-a" {
  zone_id = var.dns_zone.zone_id
  name    = "${var.year}.${var.dns_zone.name}"
  type    = "A"
  # TODO this doesn't really need to be an alias, and aliases cap TTL at 60
  # I'm doing it to avoid work plumbing IPs out of simple_vm
  alias {
    name                   = "${var.year}.${var.dns_zone.name}"
    zone_id                = var.dns_zone.id
    evaluate_target_health = false
  }
}
