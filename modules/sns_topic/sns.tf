resource "aws_sns_topic" "sns_topic" {
  name = var.topic_name
}
resource "aws_sns_topic" "error_alerts" {
  name= "error-alerts"  
}

resource "aws_sns_topic_subscription" "email_error_alerts" {
  topic_arn = aws_sns_topic.error_alerts.arn
  protocol  = "email"
  endpoint  = "ibrahimsarah839@gmail.com"
}
module "sqs" {
  source = "../sqs"
  
}
resource "aws_sns_topic_subscription" "sns_to_sqs" {
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = "sqs"
  endpoint  = module.sqs.raw_images_queue_arn
}

resource "aws_sqs_queue_policy" "allow_sns" {
  queue_url = module.sqs.raw_images_queue_url
  policy    = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = "*",
      Action = "SQS:SendMessage",
      Resource =  module.sqs.raw_images_queue_arn,
      Condition = {
        ArnEquals = {
          "aws:SourceArn" = aws_sns_topic.sns_topic.arn
        }
      }
    }]
  })
}
