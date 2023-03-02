terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
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
