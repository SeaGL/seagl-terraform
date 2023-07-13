resource "openstack_compute_instance_v2" "mailu" {
  name        = "mailu"
  flavor_name = "m1.medium"
  key_pair    = "AJ OpenStack bootstrap" # TODO lol
  security_groups = [
    "mailu" # TODO import this
  ]

  block_device {
    source_type           = "image"
    destination_type      = "volume"
    uuid                  = "5e7b09b5-03f1-4f01-bc1b-41db2e1b09d1" # Ubuntu 22.04
    volume_size           = 30
    delete_on_termination = true
  }

  network {
    name        = "general_servers2"
#    fixed_ip_v4 = "140.211.167.183" # TODO can we/should we import this...?
  }
}
