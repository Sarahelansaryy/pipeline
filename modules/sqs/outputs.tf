output "raw_images_queue_url" {
  description = "The URL of the raw images SQS queue"
  value       = aws_sqs_queue.raw_images_queue.id
}

output "raw_images_queue_arn" {
  description = "The ARN of the raw images SQS queue"
  value       = aws_sqs_queue.raw_images_queue.arn
}
