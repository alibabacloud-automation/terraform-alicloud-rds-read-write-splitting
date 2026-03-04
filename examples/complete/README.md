# Complete Example

This example demonstrates how to use the RDS Read-Write Splitting through Proxy module to create a complete read-write splitting solution using RDS database proxy.

## Features

This example creates:

- A VPC with two VSwitches in different availability zones
- An ECS instance for application deployment
- A security group with appropriate rules
- An RDS MySQL instance with high availability configuration
- A read-only RDS instance for read operations
- An RDS database proxy with read-write splitting capabilities
- A database and database account with appropriate privileges
- ECS commands for automatic application deployment

## Usage

To run this example, you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

## Variables

You need to provide values for the following variables:

- `ecs_instance_password`: Password for the ECS instance (sensitive)
- `db_password`: Password for the database account (sensitive)
- `db_name`: Database name (optional, defaults to "db_test")
- `db_user_name`: Database username (optional, defaults to "testuser")

## Example terraform.tfvars

Create a `terraform.tfvars` file with your specific values:

```hcl
ecs_instance_password = "YourECSPassword123!"
db_password           = "YourDBPassword123!"
db_name              = "myapp_db"
db_user_name         = "myapp_user"
```

## Outputs

This example outputs:

- VPC and VSwitch IDs
- ECS instance information (ID, public IP, private IP)
- RDS instance details (ID, connection string)
- Database proxy information
- ECS login address for console access

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| alicloud | >= 1.120.0 |

## Notes

1. The ECS instance will automatically execute an installation script to configure the read-write splitting application.
2. The RDS proxy provides automatic read-write splitting capabilities.
3. The read-only instance is created in a different availability zone for better availability.
4. Make sure your account has sufficient permissions to create all required resources.
5. The installation process may take 10-15 minutes to complete.
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