output "ec2_bastion_instance_id" {
  value = aws_instance.bastion.id
}
output "ec2_bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}
output "ec2_bastion_private_ip" {
  value = aws_instance.bastion.private_ip
}
output "ec2_web_blue_private_ip" {
  value = data.terraform_remote_state.ec2_blue.outputs.ec2_web_blue_private_ip
}
output "ec2_web_green_private_ip" {
  value = data.terraform_remote_state.ec2_green.outputs.ec2_web_green_private_ip
}