variable "vpc_config" {
  description = "Configuration for VPC. The attribute 'cidr_block' is required."
  type = object({
    vpc_name   = optional(string, "vpc")
    cidr_block = string
  })
}

variable "primary_vswitch_config" {
  description = "Configuration for primary VSwitch (for ECS and RDS primary instance). The attributes 'cidr_block' and 'zone_id' are required."
  type = object({
    cidr_block   = string
    zone_id      = string
    vswitch_name = optional(string, "primary-vswitch")
  })
}

variable "readonly_vswitch_config" {
  description = "Configuration for readonly VSwitch (for RDS readonly instance). The attributes 'cidr_block' and 'zone_id' are required."
  type = object({
    cidr_block   = string
    zone_id      = string
    vswitch_name = optional(string, "readonly-vswitch")
  })
}

variable "security_group_config" {
  description = "Configuration for security group."
  type = object({
    security_group_name = optional(string, "sg")
    security_group_type = optional(string, "normal")
  })
  default = {}
}

variable "security_group_rules" {
  description = "List of security group rules."
  type = list(object({
    type        = string
    ip_protocol = string
    port_range  = string
    cidr_ip     = string
  }))
  default = [
    {
      type        = "ingress"
      ip_protocol = "tcp"
      port_range  = "80/80"
      cidr_ip     = "140.205.11.1/25"
    }
  ]
}

variable "instance_config" {
  description = "Configuration for ECS instance. The attributes 'instance_name', 'image_id', 'instance_type', 'password', 'system_disk_category', and 'system_disk_size' are required."
  type = object({
    instance_name              = string
    image_id                   = string
    instance_type              = string
    password                   = string
    system_disk_category       = string
    system_disk_size           = number
    internet_max_bandwidth_out = optional(number, 5)
  })
}

variable "db_instance_config" {
  description = "Configuration for RDS database instance. The attributes 'instance_type', 'instance_storage', and 'instance_name' are required."
  type = object({
    engine            = optional(string, "MySQL")
    engine_version    = optional(string, "8.0")
    instance_type     = string
    instance_storage  = number
    instance_name     = string
    monitoring_period = optional(number, 60)
    category          = optional(string, "HighAvailability")
  })
}

variable "db_database_config" {
  description = "Configuration for RDS database. The attribute 'name' is required."
  type = object({
    name          = string
    character_set = optional(string, "utf8")
  })
}

variable "db_account_config" {
  description = "Configuration for RDS database account. The attributes 'account_name' and 'account_password' are required."
  type = object({
    account_name     = string
    account_password = string
    account_type     = optional(string, "Normal")
  })
}

variable "db_account_privilege_config" {
  description = "Configuration for database account privilege."
  type = object({
    privilege = optional(string, "ReadWrite")
  })
  default = {}
}

variable "db_proxy_config" {
  description = "Configuration for RDS database proxy."
  type = object({
    db_proxy_instance_type = optional(string, "common")
    db_proxy_features      = optional(string, "ReadWriteSplitting")
    instance_network_type  = optional(string, "VPC")
    db_proxy_instance_num  = optional(number, 2)
  })
  default = {}
}

variable "readonly_instance_config" {
  description = "Configuration for RDS readonly instance. The attributes 'instance_type', 'instance_storage', and 'instance_name' are required."
  type = object({
    instance_type    = string
    instance_storage = number
    instance_name    = string
  })
}

variable "ecs_command_config" {
  description = "Configuration for ECS command."
  type = object({
    name        = optional(string, "install")
    description = optional(string, "Install read-write splitting application")
    type        = optional(string, "RunShellScript")
    working_dir = optional(string, "/root")
    timeout     = optional(number, 3600)
  })
  default = {}
}

variable "ecs_invocation_config" {
  description = "Configuration for ECS invocation."
  type = object({
    create_timeout = optional(string, "15m")
  })
  default = {}
}

variable "custom_install_script" {
  description = "Custom installation script for ECS command. If not provided, the default script will be used."
  type        = string
  default     = null
}
