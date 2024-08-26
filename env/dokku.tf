module "dokku-vm" {
  source        = "../simple_vm"
  name          = "dokku"
  ports         = [22, 80, 443]
  instance_type = "m1.large"
  network       = "general_servers2"
  disk_size     = 40
  dns_zone      = aws_route53_zone.apex
}
