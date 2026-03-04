# VPC outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.rds_read_write_splitting.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.rds_read_write_splitting.vpc_cidr_block
}

# VSwitch outputs
output "primary_vswitch_id" {
  description = "The ID of the primary VSwitch (for ECS and RDS primary instance)"
  value       = module.rds_read_write_splitting.primary_vswitch_id
}

output "readonly_vswitch_id" {
  description = "The ID of the readonly VSwitch (for RDS readonly instance)"
  value       = module.rds_read_write_splitting.readonly_vswitch_id
}

# Security Group outputs
output "security_group_id" {
  description = "The ID of the security group"
  value       = module.rds_read_write_splitting.security_group_id
}

# ECS Instance outputs
output "ecs_instance_id" {
  description = "The ID of the ECS instance"
  value       = module.rds_read_write_splitting.ecs_instance_id
}

output "ecs_instance_public_ip" {
  description = "The public IP address of the ECS instance"
  value       = module.rds_read_write_splitting.ecs_instance_public_ip
}

output "ecs_instance_private_ip" {
  description = "The private IP address of the ECS instance"
  value       = module.rds_read_write_splitting.ecs_instance_private_ip
}

# RDS Database outputs
output "db_instance_id" {
  description = "The ID of the RDS database instance"
  value       = module.rds_read_write_splitting.db_instance_id
}

output "db_instance_connection_string" {
  description = "The connection string of the RDS database instance"
  value       = module.rds_read_write_splitting.db_instance_connection_string
}

output "db_database_name" {
  description = "The name of the database"
  value       = module.rds_read_write_splitting.db_database_name
}

output "db_account_name" {
  description = "The name of the database account"
  value       = module.rds_read_write_splitting.db_account_name
}

# RDS Readonly Instance outputs
output "readonly_instance_id" {
  description = "The ID of the RDS readonly instance"
  value       = module.rds_read_write_splitting.readonly_instance_id
}

output "readonly_instance_connection_string" {
  description = "The connection string of the RDS readonly instance"
  value       = module.rds_read_write_splitting.readonly_instance_connection_string
}

# RDS DB Proxy outputs
output "db_proxy_endpoint_id" {
  description = "The endpoint ID of the RDS database proxy"
  value       = module.rds_read_write_splitting.db_proxy_endpoint_id
}

output "db_proxy_connection_string" {
  description = "The connection string of the RDS database proxy"
  value       = module.rds_read_write_splitting.db_proxy_connection_string
}

# ECS Command outputs
output "ecs_command_id" {
  description = "The ID of the ECS command"
  value       = module.rds_read_write_splitting.ecs_command_id
}

output "ecs_invocation_id" {
  description = "The ID of the ECS invocation"
  value       = module.rds_read_write_splitting.ecs_invocation_id
}

# Login information
output "ecs_login_address" {
  description = "The ECS login address via Alibaba Cloud console"
  value       = module.rds_read_write_splitting.ecs_login_address
}