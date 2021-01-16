resource "aws_instance" "web_green" {
  ami           = "ami-021727a9bbc2d5c9c" # Use latest amazon linux 2 ami created with Packer
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    module.sg_ec2_green.security_group_id
  ]
  subnet_id = data.terraform_remote_state.vpc.outputs.subnet_id_private_1c
  associate_public_ip_address = false # NOTICE: Even if this is set as "false", it will be ALWAYS set as "true" when "auto-assign public ipv4 address" with SUBNET is set as "TRUE".
  key_name                    = "keypair_terraform" # See readme.md which describes how to create this keypair
  tags = {
    Name  = "ec2_web_green_terraform"
  }
}
