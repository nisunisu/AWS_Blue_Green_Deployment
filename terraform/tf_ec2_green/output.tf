output "ec2_web_green_instance_id" {
  value = aws_instance.web_green.id
}
output "ec2_web_green_public_ip" {
  value = aws_instance.web_green.public_ip
}
output "ec2_web_green_private_ip" {
  value = aws_instance.web_green.private_ip
}
output "ec2_security_group_id" {
  value = aws_security_group.ec2_green.id
}
