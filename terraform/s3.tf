# S3 Input Bucket
resource "aws_s3_bucket" "input" {
  bucket = "${var.project_name}-input-bucket-${var.aws_account_id}"

  tags = {
    Name = "${var.project_name}-input-bucket"
  }
}

# Block public access on input bucket
resource "aws_s3_bucket_public_access_block" "input" {
  bucket = aws_s3_bucket.input.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning
resource "aws_s3_bucket_versioning" "input" {
  bucket = aws_s3_bucket.input.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "input" {
  bucket = aws_s3_bucket.input.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 Output Bucket
resource "aws_s3_bucket" "output" {
  bucket = "${var.project_name}-output-bucket-${var.aws_account_id}"

  tags = {
    Name = "${var.project_name}-output-bucket"
  }
}

# Block public access on output bucket
resource "aws_s3_bucket_public_access_block" "output" {
  bucket = aws_s3_bucket.output.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning
resource "aws_s3_bucket_versioning" "output" {
  bucket = aws_s3_bucket.output.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "output" {
  bucket = aws_s3_bucket.output.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

output "s3_input_bucket" {
  value       = aws_s3_bucket.input.id
  description = "S3 input bucket name"
}

output "s3_output_bucket" {
  value       = aws_s3_bucket.output.id
  description = "S3 output bucket name"
}
