data "aws_vpc" "vpc" {
  tags = {
    Name = "default"
  }
}
