output "public_ip" {
  value = aws_instance.web_1.public_ip
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
## Public
resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "172.30.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1a"
  tags = {
    Name = "Subnet_public_terraform_1_${terraform.workspace}"
  }
}
resource "aws_subnet" "public_1c" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "172.30.4.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1c"
  tags = {
    Name = "Subnet_public_1c_terraform__${terraform.workspace}"
  }
}
## Private
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

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name = "Route_Table_terraform_${terraform.workspace}"
  }
}
resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.main.id
}
resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public_1c" {
  subnet_id      = aws_subnet.public_1c.id
  route_table_id = aws_route_table.public.id
}

# Security Group
resource "aws_security_group" "rds" {
  name        = "securitygroup_rds"
  description = "Allow MYSQL/Aurora"
  vpc_id      = aws_vpc.default.id
  tags = {
    Name = "securitygroup_rds_terraform_${terraform.workspace}"
  }
}
# Security Group Rule
resource "aws_security_group_rule" "Inbound_database" {
  security_group_id = aws_security_group.rds.id
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks = [
    "${var.my_home_ip}/32"
  ]
}
resource "aws_security_group_rule" "Outbound_allow_all" {
  security_group_id = aws_security_group.rds.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}

# Subnet Group for RDS
resource "aws_db_subnet_group" "default" {
  name = "rds_subnetgroup_terraform" # Uppercase is NOT allowd in "name"
  subnet_ids = [
    aws_subnet.public_1a.id,
    aws_subnet.public_1c.id
  ]
  tags = {
    Name = "RDS_SubnetGroup_terraform"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage     = 20 # GiB
  max_allocated_storage = 21 # If this item is set, "auto scaling" is enabled.
  storage_type          = "gp2"
  engine                = "mariaDB"
  engine_version        = "10.4"
  instance_class        = "db.t2.micro"
  identifier            = "rds-terraform-${terraform.workspace}"
  name                  = "terraform" # DBName must begin with a letter and contain only alphanumeric characters.
  username              = "foo"
  password              = "foobarbaz"
  db_subnet_group_name  = aws_db_subnet_group.default.id
  skip_final_snapshot   = true # If not specified or set as false, `terraform destroy` comes to an ERROR.
  publicly_accessible   = true # To set "true", the vpc with internet gateway is required.
  vpc_security_group_ids = [
    aws_security_group.rds.id
  ]
}

# -----------------------------------------------------------------
# Security Group
resource "aws_security_group" "ssh" {
  name        = "securitygroup_ssh"
  description = "Allow SSH"
  vpc_id      = aws_vpc.default.id
  tags = {
    Name = "securitygroup_ssh_terraform_${terraform.workspace}"
  }
}
# Security Group Rule
resource "aws_security_group_rule" "Inbound_ssh" {
  security_group_id = aws_security_group.ssh.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = [
    "${var.my_home_ip}/32"
  ]
}
resource "aws_security_group_rule" "Outbound_allow_all_ssh" {
  security_group_id = aws_security_group.ssh.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}

# EC2
resource "aws_instance" "web_1" {
  ami           = "ami-0a1c2ec61571737db" # amazon linux
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    aws_security_group.ssh.id
  ]
  subnet_id = aws_subnet.public_1a.id
  associate_public_ip_address = true # NOTICE: Even if this is set as "false", it will be ALWAYS set as "true" when "auto-assign public ipv4 address" with SUBNET is set as "TRUE".
  key_name                    = var.key_name

  provisioner "local-exec" {
    command = "echo ${aws_instance.web_1.public_ip} > ./output/publicip_ec2_web_1.txt"
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
    Name  = "ec2_web_1_terraform_${terraform.workspace}"
  }
}


# -----------------------------------------------------------------
# Elastic IP
# resource "aws_eip" "ip" {
#   vpc      = true
#   instance = aws_instance.web_1.id
#   tags = {
#     Name  = "EIP_terraform_test"
#     Owner = "nisunisu"
#   }
#   depends_on = [aws_instance.web_1]
# }