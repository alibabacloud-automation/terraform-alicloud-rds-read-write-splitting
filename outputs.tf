# VPC outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = alicloud_vpc.vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = alicloud_vpc.vpc.cidr_block
}

# VSwitch outputs
output "primary_vswitch_id" {
  description = "The ID of the primary VSwitch (for ECS and RDS primary instance)"
  value       = alicloud_vswitch.primary_vswitch.id
}

output "readonly_vswitch_id" {
  description = "The ID of the readonly VSwitch (for RDS readonly instance)"
  value       = alicloud_vswitch.readonly_vswitch.id
}

# Security Group outputs
output "security_group_id" {
  description = "The ID of the security group"
  value       = alicloud_security_group.security_group.id
}

# ECS Instance outputs
output "ecs_instance_id" {
  description = "The ID of the ECS instance"
  value       = alicloud_instance.ecs_instance.id
}

output "ecs_instance_public_ip" {
  description = "The public IP address of the ECS instance"
  value       = alicloud_instance.ecs_instance.public_ip
}

output "ecs_instance_private_ip" {
  description = "The private IP address of the ECS instance"
  value       = alicloud_instance.ecs_instance.primary_ip_address
}

# RDS Database outputs
output "db_instance_id" {
  description = "The ID of the RDS database instance"
  value       = alicloud_db_instance.database.id
}

output "db_instance_connection_string" {
  description = "The connection string of the RDS database instance"
  value       = alicloud_db_instance.database.connection_string
}

output "db_database_name" {
  description = "The name of the database"
  value       = alicloud_db_database.rds_database.data_base_name
}

output "db_account_name" {
  description = "The name of the database account"
  value       = alicloud_db_account.db_account.account_name
}

# RDS Readonly Instance outputs
output "readonly_instance_id" {
  description = "The ID of the RDS readonly instance"
  value       = alicloud_db_readonly_instance.readonly_instance.id
}

output "readonly_instance_connection_string" {
  description = "The connection string of the RDS readonly instance"
  value       = alicloud_db_readonly_instance.readonly_instance.connection_string
}

# RDS DB Proxy outputs
output "db_proxy_endpoint_id" {
  description = "The endpoint ID of the RDS database proxy"
  value       = alicloud_rds_db_proxy.db_proxy.db_proxy_endpoint_id
}

output "db_proxy_connection_string" {
  description = "The connection string of the RDS database proxy"
  value       = alicloud_rds_db_proxy.db_proxy.db_proxy_connection_string
}

# ECS Command outputs
output "ecs_command_id" {
  description = "The ID of the ECS command"
  value       = alicloud_ecs_command.install_script.id
}

output "ecs_invocation_id" {
  description = "The ID of the ECS invocation"
  value       = alicloud_ecs_invocation.run_install.id
}

# Login information
output "ecs_login_address" {
  description = "The ECS login address via Alibaba Cloud console"
  value       = "https://ecs-workbench.aliyun.com/?from=EcsConsole&instanceType=ecs&regionId=${data.alicloud_regions.current.regions[0].id}&instanceId=${alicloud_instance.ecs_instance.id}"
}
