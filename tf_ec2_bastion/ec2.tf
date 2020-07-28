resource "aws_instance" "bastion" {
  ami           = "ami-0a1c2ec61571737db" # amazon linux
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    data.terraform_remote_state.ec2_blue.outputs.ec2_security_group_id
  ]
  subnet_id = data.terraform_remote_state.vpc.outputs.subnet_id_public_1a
  associate_public_ip_address = true # NOTICE: Even if this is set as "false", it will be ALWAYS set as "true" when "auto-assign public ipv4 address" with SUBNET is set as "TRUE".
  key_name                    = var.key_name
  tags = {
    Name  = "ec2_bastion_terraform"
  }
}
