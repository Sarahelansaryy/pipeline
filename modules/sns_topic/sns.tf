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

