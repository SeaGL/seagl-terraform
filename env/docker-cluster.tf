module "docker-cluster-vm" {
  source        = "../simple_vm"
  name          = "docker-cluster"
  ports         = [22]
  instance_type = "m1.large"
  network       = "general_servers2"
  image_uuid    = "0cbd4881-026e-4b2f-8883-2aca75af2ca1" # CoreOS 40
  disk_size     = 20
  dns_zone      = aws_route53_zone.apex
}
