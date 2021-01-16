output "ec2_web_blue_instance_id" {
  value = aws_instance.web_blue.id
}
output "ec2_web_blue_public_ip" {
  value = aws_instance.web_blue.public_ip
}
output "ec2_web_blue_private_ip" {
  value = aws_instance.web_blue.private_ip
}
output "ec2_security_group_id" {
  value = module.sg_ec2_blue.security_group_id
}
