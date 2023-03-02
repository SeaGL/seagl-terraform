moved {
  to   = module.prod_db.random_password.osem_db_master_pass
  from = random_password.osem_db_master_pass
}

moved {
  to   = module.prod_db.aws_security_group_rule.private_out
  from = aws_security_group_rule.private_out
}

moved {
  to   = module.prod_db.aws_security_group_rule.private_in
  from = aws_security_group_rule.private_in
}

moved {
  to   = module.prod_db.aws_security_group.osem_rds_security_group
  from = aws_security_group.osem_rds_security_group
}

moved {
  to   = module.prod_db.aws_secretsmanager_secret_version.osem-db-pass-val
  from = aws_secretsmanager_secret_version.osem-db-pass-val
}

moved {
  to   = module.prod_db.aws_secretsmanager_secret.osem-db-pass
  from = aws_secretsmanager_secret.osem-db-pass
}

moved {
  to   = module.prod_db.aws_db_subnet_group.osem
  from = aws_db_subnet_group.osem
}

moved {
  to   = module.prod_db.aws_db_instance.osem
  from = aws_db_instance.osem
}
