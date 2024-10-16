module "matrix-2024-homeserver-vm" {
  source        = "../simple_vm"
  name          = "2024-ephemeral"
  ports         = [22, 80, 443, 8448]
  instance_type = "m1.medium"
  network       = "general_servers2"
  disk_size     = 30
  dns_zone      = aws_route53_zone.apex
}
