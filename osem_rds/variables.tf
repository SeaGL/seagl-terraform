variable "vpc_id" {
  description = "VPC to create the db instance in"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC's CIDR block"
  type        = string
}
