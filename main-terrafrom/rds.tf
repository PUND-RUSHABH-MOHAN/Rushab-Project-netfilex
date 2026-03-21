# RDS Subnet Group
resource "aws_db_subnet_group" "wordpress" {
  name       = "${var.project_name}-db-subnet"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

# RDS Instance
resource "aws_db_instance" "wordpress" {
  identifier     = "${var.project_name}-db"
  engine         = "mysql"
  engine_version = "8.0.35"
  instance_class = var.rds_instance_type

  allocated_storage     = 20
  storage_type          = "gp3"
  storage_encrypted     = true
  iops                  = 3000
  backup_retention_period = 7

  db_name  = "wordpress"
  username = var.db_username
  password = var.db_password

  multi_az               = false
  publicly_accessible    = false
  skip_final_snapshot    = false
  final_snapshot_identifier = "${var.project_name}-db-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"

  db_subnet_group_name   = aws_db_subnet_group.wordpress.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  tags = {
    Name = "${var.project_name}-wordpress-db"
  }

  depends_on = [aws_security_group.rds]
}

# Data source for default VPC subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_vpc" "default" {
  default = true
}

output "rds_endpoint" {
  value       = aws_db_instance.wordpress.endpoint
  description = "RDS endpoint"
}

output "rds_address" {
  value       = aws_db_instance.wordpress.address
  description = "RDS host address"
}
