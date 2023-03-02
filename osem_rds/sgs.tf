#
# Private Security Group
#

resource "aws_security_group" "osem_rds_security_group" {
  name        = "osem-private-sg"
  description = "Private SG for OSEM RDS"
  vpc_id      = var.vpc_id

  tags = {
    Name      = "osem--private-sg"
    Role      = "private"
    ManagedBy = "terraform"
  }
}

resource "aws_security_group_rule" "private_out" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.osem_rds_security_group.id
}

resource "aws_security_group_rule" "private_in" {
  type        = "ingress"
  from_port   = 3306
  to_port     = 3306
  protocol    = "-1"
  cidr_blocks = [var.vpc_cidr]

  security_group_id = aws_security_group.osem_rds_security_group.id

}
