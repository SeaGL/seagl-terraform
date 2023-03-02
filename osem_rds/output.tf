output "sg_id" {
  description = "ID of the security group to talk to RDS"
  value       = aws_security_group.osem_rds_security_group.id
}
