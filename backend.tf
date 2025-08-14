
# provider "aws" {
#   region = "eu-central-1"
# }

# # S3 Bucket for Terraform state
# resource "aws_s3_bucket" "terraform_state" {
#   bucket = "my-terraform-state-bucket-0123"

#   tags = {
#     Name        = "TerraformStateBucket"
# }
# }

# # Block public access
# resource "aws_s3_bucket_public_access_block" "state_bucket" {
#   bucket                  = aws_s3_bucket.terraform_state.id
#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }

# # Enable versioning (so old state files are kept)
# resource "aws_s3_bucket_versioning" "state_versioning" {
#   bucket = aws_s3_bucket.terraform_state.id

#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# # DynamoDB Table for state locking 
# resource "aws_dynamodb_table" "terraform_locks" {
#   name         = "terraform-locks"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }

#   tags = {
#     Name       = "TerraformLocks"
   
#   }
# }
