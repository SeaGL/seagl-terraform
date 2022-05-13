variable "vpc" {
  default = "default"
}

data "aws_vpc" "vpc" {
  tags = {
    vpc_id = var.vpc
  }
}
