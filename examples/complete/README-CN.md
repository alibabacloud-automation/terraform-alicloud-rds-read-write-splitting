# 完整示例

此示例演示如何使用 RDS 通过代理组件实现读写分离模块，创建完整的读写分离解决方案。

## 功能特性

该示例创建：

- 一个包含两个不同可用区交换机的 VPC
- 一个用于应用部署的 ECS 实例
- 一个带有适当规则的安全组
- 一个具有高可用配置的 RDS MySQL 实例
- 一个用于读操作的只读 RDS 实例
- 一个具有读写分离功能的 RDS 数据库代理
- 一个数据库和具有适当权限的数据库账号
- 用于自动应用部署的 ECS 命令

## 使用方法

要运行此示例，您需要执行：

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

注意：此示例可能会创建产生费用的资源。当您不再需要这些资源时，请运行 `terraform destroy`。

## 变量

您需要为以下变量提供值：

- `ecs_instance_password`：ECS 实例密码（敏感信息）
- `db_password`：数据库账号密码（敏感信息）
- `db_name`：数据库名称（可选，默认为 "db_test"）
- `db_user_name`：数据库用户名（可选，默认为 "testuser"）

## terraform.tfvars 示例

创建一个包含您特定值的 `terraform.tfvars` 文件：

```hcl
ecs_instance_password = "YourECSPassword123!"
db_password           = "YourDBPassword123!"
db_name              = "myapp_db"
db_user_name         = "myapp_user"
```

## 输出

此示例输出：

- VPC 和交换机 ID
- ECS 实例信息（ID、公网 IP、私网 IP）
- RDS 实例详情（ID、连接串）
- 数据库代理信息
- 用于控制台访问的 ECS 登录地址

## 要求

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| alicloud | >= 1.120.0 |

## 注意事项

1. ECS 实例将自动执行安装脚本以配置读写分离应用。
2. RDS 代理提供自动读写分离功能。
3. 只读实例创建在不同的可用区以提高可用性。
4. 确保您的账号有足够的权限创建所有必需的资源。
5. 安装过程可能需要 10-15 分钟完成。

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.120.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | 1.271.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.8.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rds_read_write_splitting"></a> [rds\_read\_write\_splitting](#module\_rds\_read\_write\_splitting) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [random_id.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [alicloud_db_instance_classes.example](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/db_instance_classes) | data source |
| [alicloud_db_zones.rds_zones](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/db_zones) | data source |
| [alicloud_images.default](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/images) | data source |
| [alicloud_instance_types.default](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/instance_types) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Database name. Must contain lowercase letters, numbers, and special characters - and \_, start with a letter, end with a letter or number, and be at most 64 characters long. | `string` | `"db_test"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Database password. The password must be 8-32 characters long and contain uppercase letters, lowercase letters, numbers and special characters. | `string` | n/a | yes |
| <a name="input_db_user_name"></a> [db\_user\_name](#input\_db\_user\_name) | Database username. Must be 2-16 characters long, only lowercase letters, numbers and underscores are allowed, must start with a letter and end with a letter or number. | `string` | `"testuser"` | no |
| <a name="input_ecs_instance_password"></a> [ecs\_instance\_password](#input\_ecs\_instance\_password) | Password for the ECS instance. The password must be 8 to 30 characters long and contain uppercase letters, lowercase letters, numbers, and special characters. | `string` | n/a | yes |

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
| <a name="output_readonly_instance_connection_string"></a> [readonly\_instance\_connection\_string](#output\_readonly\_instance\_connection\_string) | The connection string of the RDS readonly instance |
| <a name="output_readonly_instance_id"></a> [readonly\_instance\_id](#output\_readonly\_instance\_id) | The ID of the RDS readonly instance |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vswitch_ids"></a> [vswitch\_ids](#output\_vswitch\_ids) | Map of vswitch IDs |
<!-- END_TF_DOCS -->