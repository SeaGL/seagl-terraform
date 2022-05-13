terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    random = {}
    tls    = {}

  }
}


provider "aws" {
  region = "us-west-2"
}

provider "random" {
}

provider "tls" {
}