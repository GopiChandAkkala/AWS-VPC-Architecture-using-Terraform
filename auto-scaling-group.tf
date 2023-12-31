resource "aws_autoscaling_group" "VPC-asg" {  
  vpc_zone_identifier = aws_subnet.private-subnets[*].id  
  desired_capacity   = 3
  max_size           = 6
  min_size           = 3    
  health_check_type = "ELB"
  target_group_arns = [aws_lb_target_group.alb-target.arn]
  launch_template {
    id      = aws_launch_template.ec2-lt.id
    version = "$Latest"
  }
}