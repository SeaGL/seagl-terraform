module "vm" {
  source        = "../simple_vm"
  name          = "${var.year}-ephemeral"
  ports         = [22, 80, 443, 8448]
  instance_type = "m1.medium"
  network       = "general_servers2"
  disk_size     = 30
  dns_zone      = var.dns_zone
}
