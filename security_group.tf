# For RDS
resource "aws_security_group" "rds" {
  name        = "securitygroup_rds"
  description = "Allow MYSQL/Aurora"
  vpc_id      = aws_vpc.default.id
  tags = {
    Name = "securitygroup_rds_terraform_${terraform.workspace}"
  }
}
## Security Group Rule
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

# For EC2
resource "aws_security_group" "ssh" {
  name        = "securitygroup_ssh"
  description = "Allow SSH"
  vpc_id      = aws_vpc.default.id
  tags = {
    Name = "securitygroup_ssh_terraform_${terraform.workspace}"
  }
}
## Security Group Rule
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