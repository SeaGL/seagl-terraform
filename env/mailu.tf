module "mailu-vm" {
  source        = "../simple_vm"
  name          = "mailu"
  ports         = [22, 25, 80, 110, 143, 443, 465, 587, 993, 995]
  instance_type = "m1.medium"
  network       = "general_servers2"
  disk_size     = 30
  dns_zone      = aws_route53_zone.apex
}
