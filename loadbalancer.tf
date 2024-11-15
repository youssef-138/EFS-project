resource "aws_lb" "public_lb" {
  name               = "public-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_sg.id]

  # Assign both the public subnet and the two private subnets
  subnets            = [aws_subnet.public.id,aws_subnet.public2.id]

  tags = {
    Name = "public-alb"
  }
}

# Target Group for Auto Scaling Group
resource "aws_lb_target_group" "asg_tg" {
  name     = "asg-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "asg-target-group"
  }
}

# Load Balancer Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.public_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg_tg.arn
  }
}



# Output the DNS name of the Load Balancer
output "load_balancer_dns" {
  value = aws_lb.public_lb.dns_name
}