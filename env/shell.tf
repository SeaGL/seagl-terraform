module "shell-vm" {
  source        = "../simple_vm"
  name          = "shell"
  ports         = [22, 80, 443]
  instance_type = "m1.medium"
  network       = "general_servers1"
  disk_size     = 10
  dns_zone      = aws_route53_zone.apex
}
