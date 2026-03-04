# Get current region information
data "alicloud_regions" "current" {
  current = true
}

locals {
  # Default ECS installation script
  default_install_script = <<-EOF
#!/bin/sh
export ROS_DEPLOY=true
curl -fsSL https://static-aliyun-doc.oss-cn-hangzhou.aliyuncs.com/install-script/read-write-splitting-for-databases/install.sh | bash
EOF
}

# VPC Resources
resource "alicloud_vpc" "vpc" {
  vpc_name   = var.vpc_config.vpc_name
  cidr_block = var.vpc_config.cidr_block
}

# VSwitch Resources
resource "alicloud_vswitch" "primary_vswitch" {
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = var.primary_vswitch_config.cidr_block
  zone_id      = var.primary_vswitch_config.zone_id
  vswitch_name = var.primary_vswitch_config.vswitch_name
}

resource "alicloud_vswitch" "readonly_vswitch" {
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = var.readonly_vswitch_config.cidr_block
  zone_id      = var.readonly_vswitch_config.zone_id
  vswitch_name = var.readonly_vswitch_config.vswitch_name
}

# Security Group
resource "alicloud_security_group" "security_group" {
  vpc_id              = alicloud_vpc.vpc.id
  security_group_name = var.security_group_config.security_group_name
  security_group_type = var.security_group_config.security_group_type
}

resource "alicloud_security_group_rule" "rules" {
  for_each = {
    for rule in var.security_group_rules :
    "${rule.type}-${rule.ip_protocol}-${rule.port_range}" => rule
  }

  type              = each.value.type
  ip_protocol       = each.value.ip_protocol
  port_range        = each.value.port_range
  cidr_ip           = each.value.cidr_ip
  security_group_id = alicloud_security_group.security_group.id
}

# ECS Resources
resource "alicloud_instance" "ecs_instance" {
  instance_name              = var.instance_config.instance_name
  system_disk_category       = var.instance_config.system_disk_category
  system_disk_size           = var.instance_config.system_disk_size
  image_id                   = var.instance_config.image_id
  vswitch_id                 = alicloud_vswitch.primary_vswitch.id
  password                   = var.instance_config.password
  instance_type              = var.instance_config.instance_type
  internet_max_bandwidth_out = var.instance_config.internet_max_bandwidth_out
  security_groups            = [alicloud_security_group.security_group.id]
}

# RDS Resources
resource "alicloud_db_instance" "database" {
  engine             = var.db_instance_config.engine
  engine_version     = var.db_instance_config.engine_version
  instance_type      = var.db_instance_config.instance_type
  instance_storage   = var.db_instance_config.instance_storage
  instance_name      = var.db_instance_config.instance_name
  vswitch_id         = alicloud_vswitch.primary_vswitch.id
  monitoring_period  = var.db_instance_config.monitoring_period
  zone_id            = alicloud_vswitch.primary_vswitch.zone_id
  zone_id_slave_a    = alicloud_vswitch.readonly_vswitch.zone_id
  category           = var.db_instance_config.category
  security_group_ids = [alicloud_security_group.security_group.id]
}

resource "alicloud_db_database" "rds_database" {
  instance_id    = alicloud_db_instance.database.id
  data_base_name = var.db_database_config.name
  character_set  = var.db_database_config.character_set
}

resource "alicloud_db_account" "db_account" {
  db_instance_id   = alicloud_db_instance.database.id
  account_name     = var.db_account_config.account_name
  account_password = var.db_account_config.account_password
  account_type     = var.db_account_config.account_type
}

resource "alicloud_db_account_privilege" "account_privilege" {
  instance_id  = alicloud_db_instance.database.id
  account_name = alicloud_db_account.db_account.account_name
  privilege    = var.db_account_privilege_config.privilege
  db_names     = [alicloud_db_database.rds_database.data_base_name]
}

# RDS DB Proxy
resource "alicloud_rds_db_proxy" "db_proxy" {
  instance_id            = alicloud_db_instance.database.id
  db_proxy_instance_type = var.db_proxy_config.db_proxy_instance_type
  vpc_id                 = alicloud_vpc.vpc.id
  vswitch_id             = alicloud_vswitch.primary_vswitch.id
  db_proxy_features      = var.db_proxy_config.db_proxy_features
  instance_network_type  = var.db_proxy_config.instance_network_type
  db_proxy_instance_num  = var.db_proxy_config.db_proxy_instance_num
  depends_on             = [alicloud_db_account_privilege.account_privilege]
}

resource "alicloud_db_readonly_instance" "readonly_instance" {
  master_db_instance_id = alicloud_db_instance.database.id
  zone_id               = alicloud_vswitch.readonly_vswitch.zone_id
  vswitch_id            = alicloud_vswitch.readonly_vswitch.id
  instance_type         = var.readonly_instance_config.instance_type
  instance_storage      = var.readonly_instance_config.instance_storage
  instance_name         = var.readonly_instance_config.instance_name
  engine_version        = alicloud_db_instance.database.engine_version
  depends_on            = [alicloud_rds_db_proxy.db_proxy]
}

# ECS Command
resource "alicloud_ecs_command" "install_script" {
  name            = var.ecs_command_config.name
  command_content = base64encode(var.custom_install_script != null ? var.custom_install_script : local.default_install_script)
  description     = var.ecs_command_config.description
  type            = var.ecs_command_config.type
  working_dir     = var.ecs_command_config.working_dir
  timeout         = var.ecs_command_config.timeout
}

resource "alicloud_ecs_invocation" "run_install" {
  command_id  = alicloud_ecs_command.install_script.id
  instance_id = [alicloud_instance.ecs_instance.id]
  depends_on  = [alicloud_db_readonly_instance.readonly_instance]

  timeouts {
    create = var.ecs_invocation_config.create_timeout
  }
}
