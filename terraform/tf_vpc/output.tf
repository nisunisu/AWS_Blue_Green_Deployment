output "vpc_id" {
  value = aws_vpc.default.id
}
output "subnet_id_public_1a" {
  value = aws_subnet.public_1a.id
}
output "subnet_id_public_1c" {
  value = aws_subnet.public_1c.id
}
output "subnet_id_private_1c" {
  value = aws_subnet.private_1c.id
}
output "subnet_id_private_1d" {
  value = aws_subnet.private_1d.id
}