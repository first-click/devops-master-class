variable "iam_user_name_prefix" {
  type = string  #any, number, bool, list, map, set, object, tuple
  default = "my_iam_user_abc"
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
  count = 1
  name  = "${var.iam_user_name_prefix}_${count.index}"
}