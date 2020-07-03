output "EC2_Public_Ip" {
  value = aws_instance.web_1.public_ip
}
output "RDS_endpoint" {
  value = aws_db_instance.default.endpoint
}