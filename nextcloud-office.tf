module "nc-office-vm" {
  source        = "./simple_vm"
  name          = "nc-office"
  ports         = [22, 80, 443]
  instance_type = "m1.small"
  network       = "general_servers2"
  disk_size     = 15
}
