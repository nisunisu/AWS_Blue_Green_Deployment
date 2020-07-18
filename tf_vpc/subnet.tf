# Subnet
## Public
resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "172.30.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1a"
  tags = {
    Name = "Subnet_public_1a_terraform_${terraform.workspace}"
  }
}
resource "aws_subnet" "public_1c" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "172.30.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1c"
  tags = {
    Name = "Subnet_public_1c_terraform_${terraform.workspace}"
  }
}
## Private
resource "aws_subnet" "private_1c" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "172.30.3.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "ap-northeast-1c"
  tags = {
    Name = "Subnet_private_1c_terraform_${terraform.workspace}"
  }
}
resource "aws_subnet" "private_1d" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "172.30.4.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "ap-northeast-1d"
  tags = {
    Name = "Subnet_private_1d_terraform_${terraform.workspace}"
  }
}