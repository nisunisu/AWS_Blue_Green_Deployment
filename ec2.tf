# EC2
resource "aws_instance" "web_1" {
  ami           = "ami-0a1c2ec61571737db" # amazon linux
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    aws_security_group.ec2.id
  ]
  subnet_id = aws_subnet.public_1a.id
  associate_public_ip_address = true # NOTICE: Even if this is set as "false", it will be ALWAYS set as "true" when "auto-assign public ipv4 address" with SUBNET is set as "TRUE".
  key_name                    = var.key_name

  provisioner "local-exec" {
    command = "echo ${aws_instance.web_1.public_ip} > ./output/publicip_ec2_web_1.txt"
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
      "sudo yum -y install nginx mysql",
      "sudo systemctl start nginx"
    ]
  }

  tags = {
    Name  = "ec2_web_1_terraform_${terraform.workspace}"
  }
}
