resource "aws_security_group" "ec2_blue" {
  name        = "securitygroup_ec2_blue_terraform"
  description = "Allow ssh and http"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  tags = {
    Name = "securitygroup_ec2_blue_terraform"
  }
}
resource "aws_security_group_rule" "Outbound_allow_all" {
  security_group_id = aws_security_group.ec2_blue.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}