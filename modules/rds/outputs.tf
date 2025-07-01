output "rds_db_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.db_instance.endpoint
}

output "rds_security_group_id" {
  description = "The ID of the security group attached to the RDS DB"
  value       = aws_security_group.database_security_group.id
}

