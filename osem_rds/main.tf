resource "random_password" "osem_db_master_pass" {
  length           = 40
  special          = true
  min_special      = 5
  override_special = "!#$%^&*()-_=+[]{}<>:?"
  keepers = {
    pass_version = 1
  }
}

resource "aws_secretsmanager_secret" "osem-db-pass" {
  name = "db-pass-osem"
}

resource "aws_secretsmanager_secret_version" "osem-db-pass-val" {
  secret_id     = aws_secretsmanager_secret.osem-db-pass.id
  secret_string = random_password.osem_db_master_pass.result
}

resource "aws_db_subnet_group" "osem" {
  name       = "osem"
  subnet_ids = ["subnet-d507c0a2", "subnet-5a826503", "subnet-8b7adbee"]

}

resource "aws_db_instance" "osem" {
  identifier              = "osem"
  allocated_storage       = 30
  max_allocated_storage   = 100
  engine                  = "mariadb"
  engine_version          = "10.6.14"
  instance_class          = "db.t4g.micro"
  name                    = "osem"
  username                = "osem"
  password                = aws_secretsmanager_secret_version.osem-db-pass-val.secret_string
  parameter_group_name    = "default.mariadb10.6"
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_db_subnet_group.osem.name
  storage_encrypted       = true
  vpc_security_group_ids  = [aws_security_group.osem_rds_security_group.id]
  backup_retention_period = 7
}
