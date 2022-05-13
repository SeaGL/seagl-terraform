variable "vpc_id" {
  default = "vpc-7ab8bf1f"
}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}
