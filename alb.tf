# Application Load Balancer
resource "aws_lb" "default" {
  name               = "alb-terraform-${terraform.workspace}"
  internal           = false
  load_balancer_type = "application" # application or network
  security_groups    = [
    aws_security_group.alb.id
  ]
  subnets            = [
    aws_subnet.public_1a.id,
    aws_subnet.public_1c.id
  ]
  enable_deletion_protection = false

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.bucket
  #   prefix  = "default-lb"
  #   enabled = true
  # }
  tags = {
    Terraform_Workspace = terraform.workspace
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.default.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default.arn
  }
}

resource "aws_lb_target_group" "default" {
  name     = "alb-tg-${terraform.workspace}"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = aws_vpc.default.id
}

resource "aws_lb_target_group_attachment" "default" {
  target_group_arn = aws_lb_target_group.default.arn
  target_id        = aws_instance.web_1.id
  port             = 80
}