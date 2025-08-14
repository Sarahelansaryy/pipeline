variable "region" {
description = "region name"
type           = string   
}
variable "lambda_role_name" { 
  type = string 
  }


variable "lambda_function_name" { 
  type = string 
  }
variable "lambda_handler" { 
  type = string 
  }
variable "lambda_runtime" {
   type = string 
   }

variable "bucket_name" { 
  description = "s3 bucket name"
  type = string 
  }


variable "topic_name" { type = string }