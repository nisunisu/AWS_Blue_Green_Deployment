output "ec2_web1_instance_id" {
  value = aws_instance.web_1.id
}
output "ec2_web1_public_ip" {
  value = aws_instance.web_1.public_ip
}
output "ec2_web1_private_ip" {
  value = aws_instance.web_1.private_ip
}
output "ec2_security_group_id" {
  value = aws_security_group.ec2.id
}
