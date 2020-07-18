# VPC
resource "aws_vpc" "default" {
  cidr_block           = "172.30.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc_terraform_${terraform.workspace}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "igw_terraform_${terraform.workspace}"
  }
}