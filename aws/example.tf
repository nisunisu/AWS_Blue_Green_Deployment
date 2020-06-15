output "public_ip" {
  value = aws_instance.example.public_ip
}

provider "aws" {
  profile = var.aws_profile # Refer to "%UserProfile%\.aws\credential" in Windows
  region  = "ap-northeast-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0a1c2ec61571737db" # amazon linux
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    var.my_sgid # my default security group id
  ]
  associate_public_ip_address = true # NOTICE: Even if this is set as "false", it will be ALWAYS set as "true" when "auto-assign public ipv4 address" with SUBNET is set as "TRUE".
  key_name = var.key_name

  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} > ./output/my_public_ip.txt"
  }
  
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.path_private_key)
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras enable nginx1.12",
      "sudo yum -y install nginx",
      "sudo systemctl start nginx"
    ]
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