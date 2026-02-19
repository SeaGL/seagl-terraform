terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.0"
    }
    ignition = {
      source  = "community-terraform-providers/ignition"
      version = "2.6.1"
    }
  }
}


provider "aws" {
  region = "us-west-2"
}

provider "openstack" {
  auth_url          = "https://openstack.osuosl.org:5000/v3"
  region            = "RegionOne"
  tenant_id         = "03cbb624d5be494d95af475e74fcb47b"
  tenant_name       = "SeaGL"
  project_domain_id = "default"
  user_domain_name  = "Default"
}

provider "ignition" {
}
