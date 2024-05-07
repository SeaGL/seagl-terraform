terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
    tls = {}
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.50"
    }
  }
}


provider "aws" {
  region = "us-west-2"
}

provider "random" {
}

provider "tls" {
}

provider "openstack" {
  auth_url          = "https://openstack.osuosl.org:5000/v3"
  region            = "RegionOne"
  tenant_id         = "03cbb624d5be494d95af475e74fcb47b"
  tenant_name       = "SeaGL"
  project_domain_id = "default"
  user_domain_name  = "Default"
}
