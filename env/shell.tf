module "shell-vm" {
  source        = "../simple_vm"
  name          = "shell"
  ports         = [22, 80, 443]
  port_ranges   = [[7000, 8000]]
  instance_type = "m1.medium"
  network       = "general_servers1"
  disk_size     = 10
  dns_zone      = aws_route53_zone.apex
}

resource "aws_route53_record" "people_subdomain" {
  zone_id = aws_route53_zone.apex.id
  name    = "people.${var.zone_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [
    module.shell-vm.hostname
  ]
}
