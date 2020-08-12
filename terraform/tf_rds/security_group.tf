# For RDS
resource "aws_security_group" "rds" {
  name        = "securitygroup_rds_terraform"
  description = "Allow MYSQL/Aurora"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  tags = {
    Name = "securitygroup_rds_terraform"
  }
}
## Security Group Rule
resource "aws_security_group_rule" "Inbound_Database_from_blue" {
  security_group_id = aws_security_group.rds.id
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = data.terraform_remote_state.ec2_blue.outputs.ec2_security_group_id
}
resource "aws_security_group_rule" "Inbound_Database_from_green" {
  security_group_id = aws_security_group.rds.id
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = data.terraform_remote_state.ec2_green.outputs.ec2_security_group_id
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
