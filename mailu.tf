module "mailu-vm" {
  source        = "./simple_vm"
  name          = "mailu"
  ports         = [22, 25, 80, 110, 143, 443, 465, 587, 993, 995]
  instance_type = "m1.medium"
  network       = "general_servers2"
  disk_size     = 30
  # TODO replace this with a real Route 53 zone object when we control that in Terraform
  dns_zone = {
    zone_id = "Z0173878287JIU5M4KB8R"
    name    = "seagl.org"
  }
}
