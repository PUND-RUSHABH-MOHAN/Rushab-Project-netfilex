variable "aws_region" {
  default     = "ap-south-1"
  description = "AWS region"
}

variable "ec2_instance_type" {
  default     = "t2.medium"
  description = "EC2 instance type"
}

variable "rds_instance_type" {
  default     = "db.t3.micro"
  description = "RDS instance type"
}

variable "environment" {
  default     = "production"
  description = "Environment name"
}

variable "project_name" {
  default     = "rushab-ott"
  description = "Project name"
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "db_username" {
  default     = "admin"
  description = "RDS master username"
  sensitive   = true
}

variable "db_password" {
  description = "RDS master password"
  sensitive   = true
}

variable "cloudfront_domain_placeholder" {
  default     = "cloudfront_domain"
  description = "Placeholder for CloudFront domain (will be set after creation)"
}
