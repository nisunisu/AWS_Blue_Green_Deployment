resource "aws_security_group" "ec2" {
  name        = "securitygroup_ec2_terraform_${terraform.workspace}"
  description = "Allow ssh and http"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  tags = {
    Name = "securitygroup_ec2_terraform_${terraform.workspace}"
  }
}
resource "aws_security_group_rule" "Inbound_ssh" {
  security_group_id = aws_security_group.ec2.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = [
    "${var.my_home_ip}/32"
  ]
}
resource "aws_security_group_rule" "Outbound_allow_all_ssh" {
  security_group_id = aws_security_group.ec2.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}