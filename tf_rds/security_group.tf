# For RDS
resource "aws_security_group" "rds" {
  name        = "securitygroup_rds_terraform_${terraform.workspace}"
  description = "Allow MYSQL/Aurora"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
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
    "${data.terraform_remote_state.ec2.outputs.ec2_web1_private_ip}/32"
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
