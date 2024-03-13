moved {
  to   = module.prod_db.random_password.osem_db_master_pass
  from = random_password.osem_db_master_pass
}

moved {
  to   = module.prod_db.aws_security_group_rule.private_out
  from = aws_security_group_rule.private_out
}

moved {
  to   = module.prod_db.aws_security_group_rule.private_in
  from = aws_security_group_rule.private_in
}

moved {
  to   = module.prod_db.aws_security_group.osem_rds_security_group
  from = aws_security_group.osem_rds_security_group
}

moved {
  to   = module.prod_db.aws_secretsmanager_secret_version.osem-db-pass-val
  from = aws_secretsmanager_secret_version.osem-db-pass-val
}

moved {
  to   = module.prod_db.aws_secretsmanager_secret.osem-db-pass
  from = aws_secretsmanager_secret.osem-db-pass
}

moved {
  to   = module.prod_db.aws_db_subnet_group.osem
  from = aws_db_subnet_group.osem
}

moved {
  to   = module.prod_db.aws_db_instance.osem
  from = aws_db_instance.osem
}

moved {
  from = openstack_networking_secgroup_v2.mailu
  to   = module.mailu-vm.openstack_networking_secgroup_v2.main-sg
}

moved {
  from = openstack_networking_secgroup_rule_v2.mailu-ipv4-egress
  to   = module.mailu-vm.openstack_networking_secgroup_rule_v2.ipv4-egress
}

moved {
  from = openstack_networking_secgroup_rule_v2.mailu-ipv6-egress
  to   = module.mailu-vm.openstack_networking_secgroup_rule_v2.ipv6-egress
}

moved {
  from = openstack_networking_secgroup_rule_v2.mailu-icmp4-ingress
  to   = module.mailu-vm.openstack_networking_secgroup_rule_v2.icmp4-ingress
}

moved {
  from = openstack_networking_secgroup_rule_v2.mailu-tcp4-ingress
  to   = module.mailu-vm.openstack_networking_secgroup_rule_v2.tcp4-ingress
}

moved {
  from = openstack_compute_instance_v2.mailu
  to   = module.mailu-vm.openstack_compute_instance_v2.instance
}
