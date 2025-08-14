variable "bucket_name" { 
  description = "s3 bucket name"
  type = string 
  }

variable "lambda_arn" { 
  type = string
   }
variable "lambda_permission_depends_on" {
  description = "Dependency placeholder for lambda permission"
}
