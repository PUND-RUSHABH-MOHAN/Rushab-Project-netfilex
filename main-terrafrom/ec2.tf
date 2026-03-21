# Generate key pair for SSH access
resource "aws_key_pair" "wordpress" {
  key_name   = "${var.project_name}-key"
  public_key = file("~/.ssh/id_rsa.pub")  # Use your local SSH public key

  tags = {
    Name = "${var.project_name}-key"
  }
}

# EC2 Instance
resource "aws_instance" "wordpress" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ec2_instance_type
  key_name      = aws_key_pair.wordpress.key_name

  vpc_security_group_ids = [aws_security_group.ec2.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2.name

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 30
    delete_on_termination = true
    encrypted             = true
  }

  user_data = base64encode(file("${path.module}/../scripts/bootstrap-ec2.sh"))

  tags = {
    Name = "${var.project_name}-wordpress-server"
  }

  depends_on = [
    aws_security_group.ec2,
    aws_iam_instance_profile.ec2
  ]
}

# Data source for Ubuntu 22.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Elastic IP for persistent public IP
resource "aws_eip" "wordpress" {
  instance = aws_instance.wordpress.id
  domain   = "vpc"

  tags = {
    Name = "${var.project_name}-eip"
  }

  depends_on = [aws_instance.wordpress]
}

output "ec2_public_ip" {
  value       = aws_eip.wordpress.public_ip
  description = "Public IP of EC2 instance"
}

output "ec2_instance_id" {
  value       = aws_instance.wordpress.id
  description = "EC2 instance ID"
}
