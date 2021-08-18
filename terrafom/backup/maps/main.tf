variable "users" {
  default = {
    petra : { country : "US", department : "A" },
    karl : { country : "India", department : "A" },
    jon : { country : "Schweiz", department : "A" },
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
  for_each = var.users
  name     = each.key
  tags = {
    # country : each.value
    country : each.value.country
    department : each.value.department
  }
}

