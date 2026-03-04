Alibaba Cloud RDS Read-Write Splitting through Proxy Terraform Module

# terraform-alicloud-rds-read-write-splitting

English | [简体中文](https://github.com/alibabacloud-automation/terraform-alicloud-rds-read-write-splitting/blob/main/README-CN.md)

This Terraform module creates a complete RDS read-write splitting solution using database proxy on Alibaba Cloud. The module implements the [RDS read-write splitting through proxy](https://www.aliyun.com/solution/tech-solution/read-write-splitting-through-rds-proxy) solution, which involves the creation and deployment of resources such as Virtual Private Cloud (VPC), VSwitches, Elastic Compute Service (ECS), ApsaraDB RDS for MySQL with read-only instances, and database proxy for automatic read-write splitting.

## Usage

This module creates a complete infrastructure for RDS read-write splitting including VPC, ECS instance, RDS database with read-only replica, and database proxy configuration.

```terraform
data "alicloud_db_zones" "default" {
  engine                   = "MySQL"
  engine_version           = "8.0"
  instance_charge_type     = "PostPaid"
  category                 = "HighAvailability"
  db_instance_storage_type = "cloud_essd"
}

data "alicloud_db_instance_classes" "default" {
  zone_id                  = data.alicloud_db_zones.default.zones[0].id
  engine                   = "MySQL"
  engine_version           = "8.0"
  category                 = "HighAvailability"
  db_instance_storage_type = "cloud_essd"
  instance_charge_type     = "PostPaid"
}

data "alicloud_images" "default" {
  name_regex  = "^aliyun_3_x64_20G_alibase"
  most_recent = true
  owners      = "system"
}

data "alicloud_instance_types" "default" {
  availability_zone = data.alicloud_db_zones.default.zones[0].id
  cpu_core_count    = 2
  memory_size       = 4
}

locals {
  zone_id_1 = data.alicloud_db_zones.default.zones[0].id
  zone_id_2 = data.alicloud_db_zones.default.zones[1].id
}

module "rds_read_write_splitting" {
  source = "alibabacloud-automation/rds-read-write-splitting/alicloud"

  vpc_config = {
    vpc_name   = "rds-proxy-vpc"
    cidr_block = "192.168.0.0/16"
  }

  primary_vswitch_config = {
    cidr_block   = "192.168.1.0/24"
    zone_id      = local.zone_id_1
    vswitch_name = "rds-proxy-primary-vswitch"
  }

  readonly_vswitch_config = {
    cidr_block   = "192.168.2.0/24"
    zone_id      = local.zone_id_2
    vswitch_name = "rds-proxy-readonly-vswitch"
  }

  instance_config = {
    instance_name        = "rds-proxy-ecs"
    image_id             = data.alicloud_images.default.images[0].id
    instance_type        = data.alicloud_instance_types.default.instance_types[0].id
    password             = "YourECSPassword123!"
    system_disk_category = "cloud_essd"
    system_disk_size     = 40
  }

  db_instance_config = {
    instance_type    = data.alicloud_db_instance_classes.default.instance_classes[0].instance_class
    instance_storage = data.alicloud_db_instance_classes.default.instance_classes[0].storage_range.min
    instance_name    = "rds-proxy-db"
  }

  db_database_config = {
    name = "myapp_db"
  }

  db_account_config = {
    account_name     = "myapp_user"
    account_password = "YourDBPassword123!"
  }

  readonly_instance_config = {
    instance_type    = "mysqlro.n2.medium.1c"
    instance_storage = data.alicloud_db_instance_classes.default.instance_classes[0].storage_range.min
    instance_name    = "rds-proxy-readonly"
  }
}
```

## Examples

* [Complete Example](https://github.com/alibabacloud-automation/terraform-alicloud-rds-read-write-splitting/tree/main/examples/complete)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alicloud_db_account.db_account](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/db_account) | resource |
| [alicloud_db_account_privilege.account_privilege](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/db_account_privilege) | resource |
| [alicloud_db_database.rds_database](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/db_database) | resource |
| [alicloud_db_instance.database](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/db_instance) | resource |
| [alicloud_db_readonly_instance.readonly_instance](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/db_readonly_instance) | resource |
| [alicloud_ecs_command.install_script](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ecs_command) | resource |
| [alicloud_ecs_invocation.run_install](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ecs_invocation) | resource |
| [alicloud_instance.ecs_instance](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/instance) | resource |
| [alicloud_rds_db_proxy.db_proxy](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/rds_db_proxy) | resource |
| [alicloud_security_group.security_group](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/security_group) | resource |
| [alicloud_security_group_rule.rules](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/security_group_rule) | resource |
| [alicloud_vpc.vpc](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vpc) | resource |
| [alicloud_vswitch.primary_vswitch](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vswitch) | resource |
| [alicloud_vswitch.readonly_vswitch](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vswitch) | resource |
| [alicloud_regions.current](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/regions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_install_script"></a> [custom\_install\_script](#input\_custom\_install\_script) | Custom installation script for ECS command. If not provided, the default script will be used. | `string` | `null` | no |
| <a name="input_db_account_config"></a> [db\_account\_config](#input\_db\_account\_config) | Configuration for RDS database account. The attributes 'account\_name' and 'account\_password' are required. | <pre>object({<br/>    account_name     = string<br/>    account_password = string<br/>    account_type     = optional(string, "Normal")<br/>  })</pre> | n/a | yes |
| <a name="input_db_account_privilege_config"></a> [db\_account\_privilege\_config](#input\_db\_account\_privilege\_config) | Configuration for database account privilege. | <pre>object({<br/>    privilege = optional(string, "ReadWrite")<br/>  })</pre> | `{}` | no |
| <a name="input_db_database_config"></a> [db\_database\_config](#input\_db\_database\_config) | Configuration for RDS database. The attribute 'name' is required. | <pre>object({<br/>    name          = string<br/>    character_set = optional(string, "utf8")<br/>  })</pre> | n/a | yes |
| <a name="input_db_instance_config"></a> [db\_instance\_config](#input\_db\_instance\_config) | Configuration for RDS database instance. The attributes 'instance\_type', 'instance\_storage', and 'instance\_name' are required. | <pre>object({<br/>    engine            = optional(string, "MySQL")<br/>    engine_version    = optional(string, "8.0")<br/>    instance_type     = string<br/>    instance_storage  = number<br/>    instance_name     = string<br/>    monitoring_period = optional(number, 60)<br/>    category          = optional(string, "HighAvailability")<br/>  })</pre> | n/a | yes |
| <a name="input_db_proxy_config"></a> [db\_proxy\_config](#input\_db\_proxy\_config) | Configuration for RDS database proxy. | <pre>object({<br/>    db_proxy_instance_type = optional(string, "common")<br/>    db_proxy_features      = optional(string, "ReadWriteSplitting")<br/>    instance_network_type  = optional(string, "VPC")<br/>    db_proxy_instance_num  = optional(number, 2)<br/>  })</pre> | `{}` | no |
| <a name="input_ecs_command_config"></a> [ecs\_command\_config](#input\_ecs\_command\_config) | Configuration for ECS command. | <pre>object({<br/>    name        = optional(string, "install")<br/>    description = optional(string, "Install read-write splitting application")<br/>    type        = optional(string, "RunShellScript")<br/>    working_dir = optional(string, "/root")<br/>    timeout     = optional(number, 3600)<br/>  })</pre> | `{}` | no |
| <a name="input_ecs_invocation_config"></a> [ecs\_invocation\_config](#input\_ecs\_invocation\_config) | Configuration for ECS invocation. | <pre>object({<br/>    create_timeout = optional(string, "15m")<br/>  })</pre> | `{}` | no |
| <a name="input_instance_config"></a> [instance\_config](#input\_instance\_config) | Configuration for ECS instance. The attributes 'instance\_name', 'image\_id', 'instance\_type', 'password', 'system\_disk\_category', and 'system\_disk\_size' are required. | <pre>object({<br/>    instance_name              = string<br/>    image_id                   = string<br/>    instance_type              = string<br/>    password                   = string<br/>    system_disk_category       = string<br/>    system_disk_size           = number<br/>    internet_max_bandwidth_out = optional(number, 5)<br/>  })</pre> | n/a | yes |
| <a name="input_primary_vswitch_config"></a> [primary\_vswitch\_config](#input\_primary\_vswitch\_config) | Configuration for primary VSwitch (for ECS and RDS primary instance). The attributes 'cidr\_block' and 'zone\_id' are required. | <pre>object({<br/>    cidr_block   = string<br/>    zone_id      = string<br/>    vswitch_name = optional(string, "primary-vswitch")<br/>  })</pre> | n/a | yes |
| <a name="input_readonly_instance_config"></a> [readonly\_instance\_config](#input\_readonly\_instance\_config) | Configuration for RDS readonly instance. The attributes 'instance\_type', 'instance\_storage', and 'instance\_name' are required. | <pre>object({<br/>    instance_type    = string<br/>    instance_storage = number<br/>    instance_name    = string<br/>  })</pre> | n/a | yes |
| <a name="input_readonly_vswitch_config"></a> [readonly\_vswitch\_config](#input\_readonly\_vswitch\_config) | Configuration for readonly VSwitch (for RDS readonly instance). The attributes 'cidr\_block' and 'zone\_id' are required. | <pre>object({<br/>    cidr_block   = string<br/>    zone_id      = string<br/>    vswitch_name = optional(string, "readonly-vswitch")<br/>  })</pre> | n/a | yes |
| <a name="input_security_group_config"></a> [security\_group\_config](#input\_security\_group\_config) | Configuration for security group. | <pre>object({<br/>    security_group_name = optional(string, "sg")<br/>    security_group_type = optional(string, "normal")<br/>  })</pre> | `{}` | no |
| <a name="input_security_group_rules"></a> [security\_group\_rules](#input\_security\_group\_rules) | List of security group rules. | <pre>list(object({<br/>    type        = string<br/>    ip_protocol = string<br/>    port_range  = string<br/>    cidr_ip     = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "cidr_ip": "140.205.11.1/25",<br/>    "ip_protocol": "tcp",<br/>    "port_range": "80/80",<br/>    "type": "ingress"<br/>  }<br/>]</pre> | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | Configuration for VPC. The attribute 'cidr\_block' is required. | <pre>object({<br/>    vpc_name   = optional(string, "vpc")<br/>    cidr_block = string<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_account_name"></a> [db\_account\_name](#output\_db\_account\_name) | The name of the database account |
| <a name="output_db_database_name"></a> [db\_database\_name](#output\_db\_database\_name) | The name of the database |
| <a name="output_db_instance_connection_string"></a> [db\_instance\_connection\_string](#output\_db\_instance\_connection\_string) | The connection string of the RDS database instance |
| <a name="output_db_instance_id"></a> [db\_instance\_id](#output\_db\_instance\_id) | The ID of the RDS database instance |
| <a name="output_db_proxy_connection_string"></a> [db\_proxy\_connection\_string](#output\_db\_proxy\_connection\_string) | The connection string of the RDS database proxy |
| <a name="output_db_proxy_endpoint_id"></a> [db\_proxy\_endpoint\_id](#output\_db\_proxy\_endpoint\_id) | The endpoint ID of the RDS database proxy |
| <a name="output_ecs_command_id"></a> [ecs\_command\_id](#output\_ecs\_command\_id) | The ID of the ECS command |
| <a name="output_ecs_instance_id"></a> [ecs\_instance\_id](#output\_ecs\_instance\_id) | The ID of the ECS instance |
| <a name="output_ecs_instance_private_ip"></a> [ecs\_instance\_private\_ip](#output\_ecs\_instance\_private\_ip) | The private IP address of the ECS instance |
| <a name="output_ecs_instance_public_ip"></a> [ecs\_instance\_public\_ip](#output\_ecs\_instance\_public\_ip) | The public IP address of the ECS instance |
| <a name="output_ecs_invocation_id"></a> [ecs\_invocation\_id](#output\_ecs\_invocation\_id) | The ID of the ECS invocation |
| <a name="output_ecs_login_address"></a> [ecs\_login\_address](#output\_ecs\_login\_address) | The ECS login address via Alibaba Cloud console |
| <a name="output_primary_vswitch_id"></a> [primary\_vswitch\_id](#output\_primary\_vswitch\_id) | The ID of the primary VSwitch (for ECS and RDS primary instance) |
| <a name="output_readonly_instance_connection_string"></a> [readonly\_instance\_connection\_string](#output\_readonly\_instance\_connection\_string) | The connection string of the RDS readonly instance |
| <a name="output_readonly_instance_id"></a> [readonly\_instance\_id](#output\_readonly\_instance\_id) | The ID of the RDS readonly instance |
| <a name="output_readonly_vswitch_id"></a> [readonly\_vswitch\_id](#output\_readonly\_vswitch\_id) | The ID of the readonly VSwitch (for RDS readonly instance) |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
<!-- END_TF_DOCS -->

## Submit Issues

If you have any problems when using this module, please opening
a [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) and let us know.

**Note:** There does not recommend opening an issue on this repo.

## Authors

Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com).

## License

MIT Licensed. See LICENSE for full details.

## Reference

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)