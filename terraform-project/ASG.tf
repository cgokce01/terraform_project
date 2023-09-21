
## Create a Application Load Blancer
resource "aws_lb" "load-balancer" {
  name               = "project-alb"
  internal           = false
  load_balancer_type = "ipv4"
  security_groups    = [aws_security_group.project-sg.id]
  subnets            = [aws_subnet.public_subnets[0].id, aws_subnet.public_subnets[1].id, aws_subnet.public_subnets[2].id]

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.id
    prefix  = "test-lb"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}