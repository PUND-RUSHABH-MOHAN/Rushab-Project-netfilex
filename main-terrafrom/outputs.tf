output "deployment_summary" {
  value = {
    ec2_public_ip           = aws_eip.wordpress.public_ip
    ec2_instance_id         = aws_instance.wordpress.id
    rds_endpoint            = aws_db_instance.wordpress.endpoint
    s3_input_bucket         = aws_s3_bucket.input.id
    s3_output_bucket        = aws_s3_bucket.output.id
    cloudfront_domain       = aws_cloudfront_distribution.s3_distribution.domain_name
    lambda1_function_name   = aws_lambda_function.mov_to_mediaconvert.function_name
    lambda2_function_name   = aws_lambda_function.s3_to_wordpress.function_name
  }
  description = "Complete deployment summary"
}
