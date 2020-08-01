# For bastion
resource "aws_security_group" "bastion" {
  name        = "securitygroup_bastion_terraform"
  description = "Allow ssh and http"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  tags = {
    Name = "securitygroup_bastion_terraform"
  }
}
resource "aws_security_group_rule" "Inbound_ssh" {
  security_group_id = aws_security_group.bastion.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = [
    "${var.my_home_ip}/32"
  ]
}
resource "aws_security_group_rule" "Outbound_allow_all_ssh" {
  security_group_id = aws_security_group.bastion.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}

# Attach inbound ssh rule to the security group of Blue / Green EC2
resource "aws_security_group_rule" "Inbound_SSH_from_Bastion_to_Blue" {
  security_group_id = data.terraform_remote_state.ec2_blue.outputs.ec2_security_group_id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = aws_security_group.bastion.id
}
resource "aws_security_group_rule" "Inbound_SSH_from_Bastion_to_Green" {
  security_group_id = data.terraform_remote_state.ec2_green.outputs.ec2_security_group_id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = aws_security_group.bastion.id
}
resource "aws_security_group_rule" "Inbound_ICMP_from_Bastion_to_Blue" {
  security_group_id = data.terraform_remote_state.ec2_blue.outputs.ec2_security_group_id
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  source_security_group_id = aws_security_group.bastion.id
}
resource "aws_security_group_rule" "Inbound_ICMP_from_Bastion_to_Green" {
  security_group_id = data.terraform_remote_state.ec2_green.outputs.ec2_security_group_id
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  source_security_group_id = aws_security_group.bastion.id
}