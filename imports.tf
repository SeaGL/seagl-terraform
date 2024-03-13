import {
  to = openstack_networking_secgroup_v2.mailu
  id = "d422a797-f933-4a88-9daa-ad3bf51fd524"
}

import {
  to = openstack_networking_secgroup_rule_v2.mailu-tcp4-ingress["22"]
  id = "ee1d0145-522d-4bb2-8ba2-e4241c103678"
}

import {
  to = openstack_networking_secgroup_rule_v2.mailu-tcp4-ingress["25"]
  id = "1c044046-80b4-4482-8345-92537c3220ac"
}

import {
  to = openstack_networking_secgroup_rule_v2.mailu-tcp4-ingress["80"]
  id = "aff5f8e3-6d72-4378-b80c-46948b157d06"
}

import {
  to = openstack_networking_secgroup_rule_v2.mailu-tcp4-ingress["110"]
  id = "0d3c863b-8f4e-4db8-96a2-0714951e3719"
}

import {
  to = openstack_networking_secgroup_rule_v2.mailu-tcp4-ingress["143"]
  id = "b21d57e8-8f50-41d3-bb7f-42456c2e1d60"
}

import {
  to = openstack_networking_secgroup_rule_v2.mailu-tcp4-ingress["443"]
  id = "bb495a69-4c90-431a-a634-7b5459315a65"
}

import {
  to = openstack_networking_secgroup_rule_v2.mailu-tcp4-ingress["465"]
  id = "39e2ac5c-2040-4c2b-9ad5-22c424b0abcb"
}

import {
  to = openstack_networking_secgroup_rule_v2.mailu-tcp4-ingress["587"]
  id = "c664a4f7-d968-46ca-b476-c444078a6ab2"
}

import {
  to = openstack_networking_secgroup_rule_v2.mailu-tcp4-ingress["993"]
  id = "76d6ca04-3aad-466c-8b75-f75c063ca097"
}

import {
  to = openstack_networking_secgroup_rule_v2.mailu-tcp4-ingress["995"]
  id = "db876dde-1e0b-47fa-8960-6c82e495acf3"
}

import {
  to = openstack_networking_secgroup_rule_v2.mailu-ipv4-egress
  id = "880f7c96-02a4-41d9-aa0c-85236175a91b"
}

import {
  to = openstack_networking_secgroup_rule_v2.mailu-ipv6-egress
  id = "094e8ef1-4f00-4dc4-a7b0-9ad5bf09a8e0"
}

import {
  to = openstack_networking_secgroup_rule_v2.mailu-icmp4-ingress
  id = "f7332d33-9702-4b7b-af9f-e66deb8ce0af"
}
