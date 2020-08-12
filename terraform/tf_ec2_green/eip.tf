# Elastic IP
# resource "aws_eip" "ip" {
#   vpc      = true
#   instance = aws_instance.web_green.id
#   tags = {
#     Name  = "EIP_terraform_test"
#     Owner = "nisunisu"
#   }
#   depends_on = [aws_instance.web_green]
# }