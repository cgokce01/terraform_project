
## Create a Application Load Blancer
resource "aws_lb" "load-balancer" {
  name               = "project-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.project-sg.id]
  subnets            = [aws_subnet.public_subnets[0].id, aws_subnet.public_subnets[1].id, aws_subnet.public_subnets[2].id]

  enable_deletion_protection = true

  tags = {
    Environment = "project-alb"
  }
}

## Target Group
resource "aws_lb_target_group" "target-group" {
  name     = "project-tg"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = aws_vpc.project-terraform.id 


  health_check {
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 10
    timeout             = 5
    matcher             = "200"
  }
}