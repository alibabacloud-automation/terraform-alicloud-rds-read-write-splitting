provider "alicloud" {
  region = "cn-hangzhou"
}

# Random suffix for unique naming
resource "random_id" "suffix" {
  byte_length = 4
}

# Data sources for RDS configuration
data "alicloud_db_zones" "rds_zones" {
  engine                   = "MySQL"
  engine_version           = "8.0"
  instance_charge_type     = "PostPaid"
  category                 = "HighAvailability"
  db_instance_storage_type = "cloud_essd"
}

data "alicloud_db_instance_classes" "example" {
  zone_id                  = local.zone_id_1
  engine                   = data.alicloud_db_zones.rds_zones.engine
  engine_version           = data.alicloud_db_zones.rds_zones.engine_version
  category                 = data.alicloud_db_zones.rds_zones.category
  db_instance_storage_type = data.alicloud_db_zones.rds_zones.db_instance_storage_type
  instance_charge_type     = data.alicloud_db_zones.rds_zones.instance_charge_type
}

data "alicloud_instance_types" "default" {
  image_id             = data.alicloud_images.default.images[0].id
  instance_type_family = "ecs.c9i"
  availability_zone    = local.zone_id_1
}

data "alicloud_images" "default" {
  name_regex  = "^aliyun_3_x64_20G_alibase_*"
  most_recent = true
  owners      = "system"
}

locals {
  # Zone configurations
  zone_id_1 = data.alicloud_db_zones.rds_zones.zones[length(data.alicloud_db_zones.rds_zones.zones) - 1].id
  zone_id_2 = data.alicloud_db_zones.rds_zones.zones[length(data.alicloud_db_zones.rds_zones.zones) - 2].id

  # Common naming suffix
  suffix = random_id.suffix.hex
}

# Use the module
module "rds_read_write_splitting" {
  source = "../../"

  vpc_config = {
    vpc_name   = "rds-proxy-vpc-${local.suffix}"
    cidr_block = "192.168.0.0/16"
  }

  primary_vswitch_config = {
    cidr_block   = "192.168.1.0/24"
    zone_id      = local.zone_id_1
    vswitch_name = "rds-proxy-primary-vswitch-${local.suffix}"
  }

  readonly_vswitch_config = {
    cidr_block   = "192.168.2.0/24"
    zone_id      = local.zone_id_2
    vswitch_name = "rds-proxy-readonly-vswitch-${local.suffix}"
  }

  security_group_config = {
    security_group_name = "rds-proxy-sg-${local.suffix}"
    security_group_type = "normal"
  }

  security_group_rules = [
    {
      type        = "ingress"
      ip_protocol = "tcp"
      port_range  = "80/80"
      cidr_ip     = "140.205.11.1/25"
    }
  ]

  instance_config = {
    instance_name              = "rds-proxy-ecs-${local.suffix}"
    password                   = var.ecs_instance_password
    system_disk_size           = 40
    internet_max_bandwidth_out = 5
    system_disk_category       = "cloud_essd"
    image_id                   = data.alicloud_images.default.images[0].id
    instance_type              = data.alicloud_instance_types.default.instance_types[0].id
  }

  db_instance_config = {
    engine            = data.alicloud_db_instance_classes.example.engine
    engine_version    = data.alicloud_db_instance_classes.example.engine_version
    instance_type     = data.alicloud_db_instance_classes.example.instance_classes[0].instance_class
    instance_storage  = data.alicloud_db_instance_classes.example.instance_classes[0].storage_range.min
    instance_name     = "rds-proxy-db-${local.suffix}"
    monitoring_period = 60
    category          = data.alicloud_db_instance_classes.example.category
  }

  db_database_config = {
    name          = var.db_name
    character_set = "utf8"
  }

  db_account_config = {
    account_name     = var.db_user_name
    account_password = var.db_password
    account_type     = "Normal"
  }

  db_account_privilege_config = {
    privilege = "ReadWrite"
  }

  db_proxy_config = {
    db_proxy_instance_type = "common"
    db_proxy_features      = "ReadWriteSplitting"
    instance_network_type  = "VPC"
    db_proxy_instance_num  = 2
  }

  readonly_instance_config = {
    instance_type    = "mysqlro.n2.medium.1c"
    instance_storage = data.alicloud_db_instance_classes.example.instance_classes[0].storage_range.min
    instance_name    = "rds-proxy-readonly-${local.suffix}"
  }

  ecs_command_config = {
    name        = "install-rds-proxy-${local.suffix}"
    description = "Install read-write splitting application"
    type        = "RunShellScript"
    working_dir = "/root"
    timeout     = 3600
  }

  ecs_invocation_config = {
    create_timeout = "15m"
  }
}
