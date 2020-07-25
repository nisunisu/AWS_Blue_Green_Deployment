resource "aws_security_group" "alb" {
  name        = "securitygroup_alb_terraform_${terraform.workspace}"
  description = "Allow http"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  tags = {
    Name = "securitygroup_alb_terraform_${terraform.workspace}"
  }
}
resource "aws_security_group_rule" "Inbound_http" {
  security_group_id = aws_security_group.alb.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}
resource "aws_security_group_rule" "Outbound_http" {
  security_group_id = aws_security_group.alb.id
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = data.terraform_remote_state.ec2_blue.outputs.ec2_security_group_id
}

# Add EC2 security group to allow http from ALB
resource "aws_security_group_rule" "Inbound_alb_http" {
  security_group_id = data.terraform_remote_state.ec2_blue.outputs.ec2_security_group_id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = aws_security_group.alb.id
}