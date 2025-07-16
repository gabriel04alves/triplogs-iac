# AWS Region
variable "region" {
  description = "AWS region for the infrastructure"
  type        = string
  default     = "us-east-1"
}

# Database Variables
variable "db_name" {
  description = "Name of the PostgreSQL database"
  type        = string
  default     = "triplogs"
}

variable "db_username" {
  description = "Username for the PostgreSQL database"
  type        = string
  sensitive   = true
  default     = "postgres"
}

variable "db_password" {
  description = "Password for the PostgreSQL database"
  type        = string
  sensitive   = true
}

variable "db_port" {
  description = "Port for the PostgreSQL database"
  type        = string
  default     = "5432"
}

variable "debug" {
  description = "Debug mode for the application"
  type        = string
  default     = "False"
}