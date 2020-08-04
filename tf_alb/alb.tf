# Application Load Balancer
resource "aws_lb" "default" {
  name               = "alb-terraform"
  internal           = false
  load_balancer_type = "application" # application or network
  security_groups    = [
    aws_security_group.alb.id
  ]
  subnets            = [
    data.terraform_remote_state.vpc.outputs.subnet_id_public_1a,
    data.terraform_remote_state.vpc.outputs.subnet_id_public_1c
  ]
  enable_deletion_protection = false

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.bucket
  #   prefix  = "default-lb"
  #   enabled = true
  # }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.default.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type            = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.ec2_blue.arn
        weight = var.weight_blue
      }
      target_group {
        arn    = aws_lb_target_group.ec2_green.arn
        weight = var.weight_green
      }
    }
  }
}

resource "aws_lb_target_group" "ec2_blue" {
  name     = "TargetGroup-blue"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = data.terraform_remote_state.vpc.outputs.vpc_id
}

resource "aws_lb_target_group" "ec2_green" {
  name     = "TargetGroup-green"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = data.terraform_remote_state.vpc.outputs.vpc_id
}

resource "aws_lb_target_group_attachment" "ec2_blue" {
  target_group_arn = aws_lb_target_group.ec2_blue.arn
  target_id        = data.terraform_remote_state.ec2_blue.outputs.ec2_web_blue_instance_id
  port             = 80
}

resource "aws_lb_target_group_attachment" "ec2_green" {
  target_group_arn = aws_lb_target_group.ec2_green.arn
  target_id        = data.terraform_remote_state.ec2_green.outputs.ec2_web_green_instance_id
  port             = 80
}