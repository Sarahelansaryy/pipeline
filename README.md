# Terraform AWS Lambda + S3 + SNS + EKS + SQS Setup

# 📌 Project Overview

This project provisions AWS infrastructure using **Terraform** with a modular setup for an image processing pipeline.

## Components

- **Lambda Function**
  - Node.js handler for processing events from S3 or other triggers.

- **S3 Buckets**
  - Store original and processed images.

- **SNS Topics**
  - Used for notifications and alerting.
  - Publishes object keys to **SQS** for downstream processing.

- **SQS Queues**
  - Subscribed to SNS to receive object keys.
  - Triggers **EKS pods** to process images.

- **EKS Cluster**
  - Pods subscribe to SQS and resize images before uploading them back to S3.

- **Terraform Remote Backend**
  - Uses **S3 + DynamoDB** to store Terraform state and support locking.


## Architecture Flow

```mermaid
flowchart LR
    A[S3 Bucket (Upload Image)] -->|Triggers| B[Lambda Function]
    B -->|Publishes Object Key| C[SNS Topic]
    C -->|Sends Message| D[SQS Queue]
    D -->|Triggers| E[EKS Pod]
    E -->|Uploads Resized Image| F[S3 Bucket (Processed Image)]


---

## 📂 Project Structure
```bash
project/
│
├── main.tf # Main Terraform configuration (backend, modules, error alerts)
├── variables.tf # Input variable definitions
├── terraform.tfvars # Variable values
├── outputs.tf # Project outputs
├── backend.tf # Creates S3 bucket & DynamoDB for remote state
│
├── modules/
│ ├── handler_function/ # Node.js source code & dependencies
│ ├── lambda_function/ # Lambda deployment configuration
│ ├── s3_setup/ # S3 application buckets configuration
│ └── sns_topic/ # SNS topics configuration
│
└── eks-app/
├── Dockerfile # Container build instructions
├── eks-app.js # Application code (SQS processing & thumbnail upload)
└── deployment.yaml # Kubernetes deployment manifest
    
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
# Building & Deploying the EKS App

## 1. Install Node.js Modules
Initialize a new Node.js project:
```bash
npm init -y
```
## 2. Install AWS SDK and Sharp

Install required dependencies for AWS services integration and image processing:
``` bash
npm install aws-sdk sharp
```
### Deploying the Docker Image to Amazon ECR
1. Create an ECR Repository
```bash
aws ecr create-repository --repository-name sarah-image-processor
```
2. Authenticate Docker with ECR
```bash
aws ecr get-login-password --region eu-central-1 \
| docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.eu-central-1.amazonaws.com
```

3. Build the Docker Image

Make sure Docker Engine is running before building.
```bash

docker build -t image-processor .
```

4. Tag the Docker Image
```bash 
docker tag image-processor:latest <ACCOUNT_ID>.dkr.ecr.eu-central-1.amazonaws.com/sarah-image-processor:latest
```

5. Push the Image to ECR
``` bash
docker push <ACCOUNT_ID>.dkr.ecr.eu-central-1.amazonaws.com/sarah-image-processor:latest
```

6. Verify the Image in ECR

List available images to confirm the upload:
```bash

aws ecr list-images --repository-name sarah-image-processor --region eu-central-1
```
7. Reference the Image in Kubernetes Deployment

Update your Kubernetes deployment.yaml file with the ECR image URI.
### 🧹 Destroying Infrastructure
To remove all resources:
```bash
terraform destroy
```
