resource "aws_s3_bucket" "raw_images" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_notification" "raw_images_event" {
  bucket = aws_s3_bucket.raw_images.id

  lambda_function {
    lambda_function_arn = var.lambda_arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [var.lambda_permission_depends_on]
}
