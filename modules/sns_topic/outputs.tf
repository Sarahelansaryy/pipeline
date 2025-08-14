output "topic_arn" {
  value = aws_sns_topic.sns_topic.arn
}
output "error_alerts_arn" {
  value = aws_sns_topic.error_alerts.arn
  
}