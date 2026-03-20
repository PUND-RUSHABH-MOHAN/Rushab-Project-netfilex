terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  # NO STATE LOCKING - Simple local state (as requested)
  # If you want remote state later, add this:
  # backend "s3" {
  #   bucket         = "your-terraform-state-bucket"
  #   key            = "rushab-ott/terraform.tfstate"
  #   region         = "ap-south-1"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    }
  }
}
