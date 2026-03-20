# Lambda #1 - MOV to MediaConvert
resource "aws_lambda_function" "mov_to_mediaconvert" {
  filename         = data.archive_file.lambda1.output_path
  function_name    = "${var.project_name}-mov-to-mediaconvert"
  role             = aws_iam_role.lambda1.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  timeout          = 60
  memory_size      = 128

  source_code_hash = data.archive_file.lambda1.output_base64sha256

  environment {
    variables = {
      MEDIACONVERT_ROLE_ARN = aws_iam_role.mediaconvert.arn
      OUTPUT_BUCKET         = aws_s3_bucket.output.id
    }
  }

  tags = {
    Name = "${var.project_name}-lambda1"
  }
}

# Archive Lambda #1 code
data "archive_file" "lambda1" {
  type        = "zip"
  source_file = "${path.module}/../lambda-functions/lambda1-mov-to-mediaconvert/lambda_function.py"
  output_path = "${path.module}/../lambda-functions/lambda1-mov-to-mediaconvert/lambda1.zip"
}

# S3 trigger for Lambda #1
resource "aws_s3_bucket_notification" "input_bucket" {
  bucket      = aws_s3_bucket.input.id
  eventbridge = true  # Using EventBridge for more reliable notifications
}

resource "aws_lambda_permission" "s3_input" {
  statement_id  = "AllowExecutionFromS3Input"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.mov_to_mediaconvert.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.input.arn
}

# Lambda #2 - S3 to WordPress
resource "aws_lambda_function" "s3_to_wordpress" {
  filename         = data.archive_file.lambda2.output_path
  function_name    = "${var.project_name}-s3-to-wordpress"
  role             = aws_iam_role.lambda2.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  timeout          = 120
  memory_size      = 512

  source_code_hash = data.archive_file.lambda2.output_base64sha256

  environment {
    variables = {
      OUTPUT_BUCKET = aws_s3_bucket.output.id
    }
  }

  tags = {
    Name = "${var.project_name}-lambda2"
  }
}

# Archive Lambda #2 code
data "archive_file" "lambda2" {
  type        = "zip"
  source_file = "${path.module}/../lambda-functions/lambda2-s3-to-wordpress/lambda_function.py"
  output_path = "${path.module}/../lambda-functions/lambda2-s3-to-wordpress/lambda2.zip"
}

# S3 trigger for Lambda #2
resource "aws_lambda_permission" "s3_output" {
  statement_id  = "AllowExecutionFromS3Output"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_to_wordpress.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.output.arn
}

output "lambda1_arn" {
  value = aws_lambda_function.mov_to_mediaconvert.arn
}

output "lambda2_arn" {
  value = aws_lambda_function.s3_to_wordpress.arn
}
