# Configure the AWS Provider
provider "aws" {
  version = "~> 2.0"
  region  = "ap-south-1"
}

resource "aws_ecr_repository" "ECR" {
  name = "myrepo"
  image_scanning_configuration {
    scan_on_push = true
  }
}
