variable "ecs_instance_password" {
  description = "Password for the ECS instance. The password must be 8 to 30 characters long and contain uppercase letters, lowercase letters, numbers, and special characters."
  type        = string
  sensitive   = true
  default     = "YourPassword123!"
}

variable "db_name" {
  description = "Database name. Must contain lowercase letters, numbers, and special characters - and _, start with a letter, end with a letter or number, and be at most 64 characters long."
  type        = string
  default     = "db_test"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-_]{0,62}[a-z0-9]$", var.db_name))
    error_message = "Database name format is incorrect. The name should consist of lowercase letters, numbers and special characters - and _, start with a letter, end with a letter or number, and be at most 64 characters."
  }
}

variable "db_user_name" {
  description = "Database username. Must be 2-16 characters long, only lowercase letters, numbers and underscores are allowed, must start with a letter and end with a letter or number."
  type        = string
  default     = "testuser"

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_]{0,30}[a-zA-Z0-9]$", var.db_user_name))
    error_message = "Database username must start with a letter, end with a letter or number, and can only contain letters, numbers and underscores. Maximum 32 characters."
  }
}

variable "db_password" {
  description = "Database password. The password must be 8-32 characters long and contain uppercase letters, lowercase letters, numbers and special characters."
  type        = string
  sensitive   = true
  default     = "YourDBPassword123!"
}