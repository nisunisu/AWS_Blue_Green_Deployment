output "public_ip" {
  value = aws_instance.example.public_ip
}

provider "aws" {
  profile = var.aws_profile # Refer to "%UserProfile%\.aws\credential" in Windows
  region  = "ap-northeast-1"
}

terraform {
  backend "s3" {
    region  = "ap-northeast-1"
    encrypt = true
    key     = "terraform.tfstate"
    # Variables NOT allowed here. So, about those items below, See .tfbackend
    #   - bucket
    #   - profile
  }
}

# -----------------------------------------------------------------
# VPC
resource "aws_vpc" "default" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc_terraform_${terraform.workspace}"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "PublicRouteTable_terraform_${terraform.workspace}"
  }
}

# Private Route Table
resource "aws_route_table" "private_0" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "PrivateRouteTable_terraform_0_${terraform.workspace}"
  }
}
resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "PrivateRouteTable_terraform_1_${terraform.workspace}"
  }
}

# -----------------------------------------------------------------
# EC2
resource "aws_instance" "example" {
  ami           = "ami-0a1c2ec61571737db" # amazon linux
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    var.my_sgid # my default security group id
  ]
  associate_public_ip_address = true # NOTICE: Even if this is set as "false", it will be ALWAYS set as "true" when "auto-assign public ipv4 address" with SUBNET is set as "TRUE".
  key_name                    = var.key_name

  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} > ./output/my_public_ip.txt"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.path_private_key)
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras enable nginx1.12",
      "sudo yum -y install nginx",
      "sudo systemctl start nginx"
    ]
  }

  tags = {
    Name  = "terraform-test"
    Owner = "nisunisu"
  }
}


# -----------------------------------------------------------------
# Elastic IP
# resource "aws_eip" "ip" {
#   vpc      = true
#   instance = aws_instance.example.id
#   tags = {
#     Name  = "EIP_terraform_test"
#     Owner = "nisunisu"
#   }
#   depends_on = [aws_instance.example]
# }