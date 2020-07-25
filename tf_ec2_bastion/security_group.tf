resource "aws_security_group_rule" "Inbound_SELF" {
  security_group_id = data.terraform_remote_state.ec2_blue.outputs.ec2_security_group_id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  self              = true # bastion belongs to the same security group with the one which "web_1" EC2 belongs to.
}