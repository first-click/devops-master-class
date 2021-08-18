variable application_name {
  default = "backend-state"
}

variable project_name {
  default = "users"
}

variable environment {
  default = "dev"
}


terraform {
  backend "s3" {
      bucket = "dev-applications-backend-state-devops-01"
    key = "application_name-project_name-environment" 
  region = "us-east-1"
  dynamodb_table = "dev_application_locks"
  encrypt = true

  }
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"

}


resource "aws_iam_user" "my_iam_user" {
    name = "${terraform.workspace}_my_iam_user_abc_updated"
}

