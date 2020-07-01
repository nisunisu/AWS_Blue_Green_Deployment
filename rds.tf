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

# RDS
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
  publicly_accessible   = true # To set "true", IGW & Security Group which allows DB access are required. When it is set as "true", a public IP is attached to RDS but it is not shown in any section of AWS management console (See : https://docs.aws.amazon.com/ja_jp/AmazonRDS/latest/UserGuide/USER_VPC.WorkingWithRDSInstanceinaVPC.html#USER_VPC.Hiding)
  vpc_security_group_ids = [
    aws_security_group.rds.id
  ]
}