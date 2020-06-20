output "public_ip" {
  value = aws_instance.example.public_ip
}

provider "aws" {
  profile = var.aws_profile # Refer to "%UserProfile%\.aws\credential" in Windows
  region  = "ap-northeast-1"
}

# -----------------------------------------------------------------
# Terraform backend
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

# Subnet
resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "172.30.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1a"
  tags = {
    Name = "Subnet_public_terraform_1_${terraform.workspace}"
  }
}

resource "aws_subnet" "private_1c" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "172.30.2.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "ap-northeast-1c"
  tags = {
    Name = "Subnet_private_terraform_1_${terraform.workspace}"
  }
}
resource "aws_subnet" "private_1d" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "172.30.3.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "ap-northeast-1d"
  tags = {
    Name = "Subnet_private_terraform_2_${terraform.workspace}"
  }
}

# Subnet Group for RDS
resource "aws_db_subnet_group" "default" {
  name = "rds_subnetgroup_terraform" # Uppercase is NOT allowd in "name"
  subnet_ids = [
    aws_subnet.public_1a.id,
    aws_subnet.private_1c.id,
    aws_subnet.private_1d.id
  ]
  tags = {
    Name = "RDS_SubnetGroup_terraform"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mariaDB"
  engine_version       = "10.4"
  instance_class       = "db.t2.micro"
  name                 = "dbinstanceterraform" # DBName must begin with a letter and contain only alphanumeric characters.
  username             = "foo"
  password             = "foobarbaz"
  db_subnet_group_name = aws_db_subnet_group.default.id
  skip_final_snapshot  = true # If not specified or set as false, `terraform destroy` comes to an ERROR.
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