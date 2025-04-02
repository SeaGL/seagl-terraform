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
moved {
  from = openstack_networking_secgroup_v2.nc-office
  to   = module.nc-office-vm.openstack_networking_secgroup_v2.main-sg
}

moved {
  from = openstack_networking_secgroup_rule_v2.nc-office-ipv4-egress
  to   = module.nc-office-vm.openstack_networking_secgroup_rule_v2.ipv4-egress
}

moved {
  from = openstack_networking_secgroup_rule_v2.nc-office-ipv6-egress
  to   = module.nc-office-vm.openstack_networking_secgroup_rule_v2.ipv6-egress
}

moved {
  from = openstack_networking_secgroup_rule_v2.nc-office-icmp4-ingress
  to   = module.nc-office-vm.openstack_networking_secgroup_rule_v2.icmp4-ingress
}

moved {
  from = openstack_networking_secgroup_rule_v2.nc-office-tcp4-ingress
  to   = module.nc-office-vm.openstack_networking_secgroup_rule_v2.tcp4-ingress
}

moved {
  from = openstack_compute_instance_v2.nc-office
  to   = module.nc-office-vm.openstack_compute_instance_v2.instance
}

moved {
  from = aws_route53_zone.apex
  to   = module.production_env.aws_route53_zone.apex
}

moved {
  from = aws_ses_domain_identity.seagl
  to   = module.production_env.aws_ses_domain_identity.main
}

moved {
  from = aws_route53_record.route_53_root_txt
  to   = module.production_env.aws_route53_record.route_53_root_txt
}

moved {
  from = aws_ses_domain_dkim.email_dkim
  to   = module.production_env.aws_ses_domain_dkim.email_dkim
}

moved {
  from = aws_route53_record.email_dkim_records
  to   = module.production_env.aws_route53_record.email_dkim_records
}

moved {
  from = aws_route53_record.route_53_dmarc_txt
  to   = module.production_env.aws_route53_record.route_53_dmarc_txt
}

moved {
  from = aws_route53_record.dokku_wildcard
  to   = module.production_env.aws_route53_record.dokku_wildcard
}

moved {
  from = aws_route53_record.mailu-test-a
  to   = module.production_env.aws_route53_record.mailu-test-a
}

moved {
  from = aws_route53_record.mailu-test-mx
  to   = module.production_env.aws_route53_record.mailu-test-mx
}

moved {
  from = aws_route53_record.mailu-test-spf
  to   = module.production_env.aws_route53_record.mailu-test-spf
}

moved {
  from = aws_route53_record.mailu-test-autoconfig-srv
  to   = module.production_env.aws_route53_record.mailu-test-autoconfig-srv
}

moved {
  from = aws_route53_record.mailu-test-autoconfig-cname
  to   = module.production_env.aws_route53_record.mailu-test-autoconfig-cname
}

moved {
  from = aws_route53_record.mailu-test-dkim
  to   = module.production_env.aws_route53_record.mailu-test-dkim
}

moved {
  from = aws_route53_record.mailu-test-dmarc
  to   = module.production_env.aws_route53_record.mailu-test-dmarc
}

moved {
  from = module.mailu-vm
  to   = module.production_env.module.mailu-vm
}

moved {
  from = module.nc-office-vm
  to   = module.production_env.module.nc-office-vm
}
