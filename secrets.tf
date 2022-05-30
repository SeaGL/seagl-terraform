# example of creating keypairs for VMs and stuff the data into Secretsmanager
#
# # create a Keypair for TeamCity Agent01
# resource "tls_private_key" "teamcity_agent01" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "aws_key_pair" "teamcity_agent01_keypair" {
#   key_name   = "teamcity-agent01"
#   public_key = tls_private_key.teamcity_agent01.public_key_openssh
# }

# # store the TeamCity Agent01 SSH key in SecretsManager
# resource "aws_secretsmanager_secret" "teamcity_agent01_secret_key" {
#   name        = var.teamcity_agent01_public_key_name
#   description = "SSH Key used by TeamCity Agent 01 host"
# }

# resource "aws_secretsmanager_secret_version" "teamcity_agent01_secret_key_value" {
#   secret_id     = aws_secretsmanager_secret.teamcity_agent01_secret_key.id
#   secret_string = tls_private_key.teamcity_agent01.private_key_pem
# }
