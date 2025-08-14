output "raw_images_bucket_name" {
  value = aws_s3_bucket.raw_images.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.raw_images.arn
}
