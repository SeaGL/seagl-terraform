module "nc-office-vm" {
  source        = "./simple_vm"
  name          = "nc-office"
  ports         = [22, 80, 443]
  instance_type = "m1.small"
  network       = "general_servers2"
  disk_size     = 15
  # TODO replace this with a real Route 53 zone object when we control that in Terraform
  dns_zone = {
    zone_id = "Z0173878287JIU5M4KB8R"
    name    = "seagl.org"
  }
}
