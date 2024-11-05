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
    name                   = module.vm.hostname
    zone_id                = var.dns_zone.id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "dns-matrix-a" {
  zone_id = var.dns_zone.zone_id
  name    = "matrix.${var.year}.${var.dns_zone.name}"
  type    = "A"
  # TODO same as above
  alias {
    name                   = module.vm.hostname
    zone_id                = var.dns_zone.id
    evaluate_target_health = false
  }
}

# Supposedly, we have Element deactivated. But Traefik still tries to obtain ACME certs for it, as seen in the journald logs.
# TODO: report this as a bug upstream
resource "aws_route53_record" "element-cname" {
  zone_id = var.dns_zone.zone_id
  name    = "element.${var.year}.${var.dns_zone.name}"
  type    = "CNAME"
  ttl     = 300
  records = [
    "${var.year}.${var.dns_zone.name}"
  ]
}
