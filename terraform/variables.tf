
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "aws_az" {
  description = "AWS availability zone"
  type        = string
  default     = "us-east-1a"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "key_name" {
  description = "Name for the AWS key pair"
  type        = string
}

variable "public_key_path" {
  description = "Path to the public SSH key file"
  type        = string
}

variable "private_key_path" {
  description = "Path to the private SSH key file"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for Ubuntu 22.04 (t2.micro compatible)"
  type        = string
}
