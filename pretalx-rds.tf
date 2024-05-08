# Pretalx DB

# TODO I copied this from the OSEM RDS configuration and I don't really understand what it means.
# (But this instance is temporary anyways; we want to move to OSUOSL's.)
resource "aws_db_subnet_group" "pretalx" {
  name       = "pretalx-prod"
  subnet_ids = ["subnet-d507c0a2", "subnet-5a826503", "subnet-8b7adbee"]
}

resource "aws_db_instance" "pretalx" {
  identifier                  = "pretalx-prod"
  db_name                     = "pretalx"
  allocated_storage           = 10
  max_allocated_storage       = 100
  engine                      = "postgres"
  engine_version              = "13.14"
  instance_class              = "db.t4g.micro"
  username                    = "pretalxadmin"
  manage_master_user_password = true
  db_subnet_group_name        = aws_db_subnet_group.pretalx.name
  vpc_security_group_ids      = [aws_security_group.pretalx-rds-security-group.id]
  backup_retention_period     = 7
  ca_cert_identifier          = "rds-ca-rsa2048-g1"
}

# Pretalx DB SG

resource "aws_security_group" "pretalx-rds-security-group" {
  name   = "pretalx-rds-prod"
  vpc_id = data.aws_vpc.vpc.id
}

resource "aws_security_group_rule" "pretalx-rds-out" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.pretalx-rds-security-group.id
}

resource "aws_security_group_rule" "pretalx-rds-in" {
  type        = "ingress"
  from_port   = 3306
  to_port     = 3306
  protocol    = "-1"
  cidr_blocks = [data.aws_vpc.vpc.cidr_block]

  security_group_id = aws_security_group.pretalx-rds-security-group.id

}
