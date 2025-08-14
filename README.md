# Terraform AWS Lambda + S3 + SNS Setup

## 📌 Project Overview
This project provisions AWS infrastructure using **Terraform** with a modular setup:
- **Lambda Function** (Node.js handler)
- **S3 Buckets** for application storage
- **SNS Topics** for notifications
- **Remote Backend** (S3 + DynamoDB) for Terraform state

---

## 📂 Project Structure
```bash
project/
│
├── main.tf # Backend config & module calls
├── variables.tf # Input variable definitions
├── terraform.tfvars # Variable values
├── outputs.tf # Project outputs
│
├── backend/ # Remote backend bootstrap
│ ├── s3_backend.tf # Creates S3 bucket & DynamoDB table for state
│ └── outputs.tf
│
├── modules/
│ ├── handler_function/ # Node.js source code & dependencies
│ ├── lambda_function/ # Terraform for Lambda deployment
│ ├── s3_setup/ # Terraform for S3 application buckets
│ └── sns_topic/ # Terraform for SNS topics

```
---

## ⚙️ Prerequisites
- **Terraform** ≥ 1.3.x
- **AWS CLI** configured with credentials
- **Node.js** (for Lambda handler development)
- IAM permissions to manage:
  - S3
  - DynamoDB
  - Lambda
  - SNS
  - IAM Roles/Policies

---

## 🚀 Deployment Steps

### 1️⃣ Bootstrap the Remote Backend (One-time)
First, deploy the S3 bucket and DynamoDB table to store the Terraform state.

```bash
cd backend
terraform init
terraform apply
```
This will create:

S3 Bucket → Stores the .tfstate file

DynamoDB Table → Locks state to prevent concurrent changes

### 2️⃣ Initialize Terraform in Root Project
From the root directory:

```bash
terraform init
```
Connects to the remote backend (S3 + DynamoDB)

Downloads all providers & modules

### 3️⃣ Deploy Infrastructure
``` bash

terraform apply
```
This will:

Package and deploy the Lambda function

Create S3 buckets for application data

Create SNS topics for notifications

### 🛠 Notes
Lambda Packaging: Ensure the aws-sdk module is not bundled in Lambda if using the AWS-managed runtime (already included).


Order of Deployment: Backend → Main project modules.
### 🧹 Destroying Infrastructure
To remove all resources:
```bash
terraform destroy
```

