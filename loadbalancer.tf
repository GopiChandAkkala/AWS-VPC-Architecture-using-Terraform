resource "aws_alb" "vpc-lb" {
  name               = "vpc-lb"
  
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.vpc-sgp.id]
  subnets            = [for subnet in aws_subnet.public-subnets : subnet.id]
  enable_http2 = true  
}

resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_alb.vpc-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb-target.arn
  }
}

resource "aws_lb_target_group" "alb-target" {
  name        = "vpc-alb-target-group"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.my-vpc.id
  load_balancing_cross_zone_enabled = true
}