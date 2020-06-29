output "ec2_public_ip" {
  value = aws_instance.web_1.public_ip
}
output "rds_endpoint" {
  value = aws_db_instance.default.endpoint
}