terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-0123" 
    key            = "prod/terraform.tfstate"           
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"                    
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-central-1"
}

module "sns_topic" {
  source     = "./modules/sns_topic"
  topic_name = var.topic_name
}

module "lambda_function" {
  source                = "./modules/lambda_function"
  lambda_role_name      = var.lambda_role_name
  sns_topic_arn         = module.sns_topic.topic_arn
  lambda_function_name  = var.lambda_function_name
  lambda_handler        = var.lambda_handler
  lambda_runtime        = var.lambda_runtime
  s3_bucket_arn         = module.s3_setup.bucket_arn
}

module "s3_setup" {
  source                        = "./modules/s3_setup"
  bucket_name                   = var.bucket_name
  lambda_arn                    = module.lambda_function.lambda_arn
  lambda_permission_depends_on  = module.lambda_function.lambda_permission_depends_on
}

# CloudWatch Alarm on  errors
resource "aws_cloudwatch_metric_alarm" "lambda_error_alarm" {
  alarm_name          = "error-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = 1

  alarm_description   = "Triggers SNS when there are errors"
  alarm_actions       = [module.sns_topic.error_alerts_arn]

  dimensions = {
    FunctionName = module.lambda_function.lambda_function_name
  }
}
module "sqs" {
  source = "./modules/sqs"
  
}

