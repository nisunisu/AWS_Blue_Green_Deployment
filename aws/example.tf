provider "aws" {
  profile = "default" # "default" means "%UserProfile%\.aws\credential" in Windows
  region  = "ap-northeast-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0a1c2ec61571737db" # amazon linux
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    var.my_sgid # my default security group id
  ]
  associate_public_ip_address = true # NOTICE: Even if this is set as "false", it will be ALWAYS set as "true" when "auto-assign public ipv4 address" with SUBNET is set as "TRUE".
  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} > ./output/my_public_ip.txt"
  }
  tags = {
    Name  = "terraform-test"
    Owner = "nisunisu"
  }
}

# resource "aws_eip" "ip" {
#   vpc      = true
#   instance = aws_instance.example.id
#   tags = {
#     Name  = "EIP_terraform_test"
#     Owner = "nisunisu"
#   }
#   depends_on = [aws_instance.example]
# }