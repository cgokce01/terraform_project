
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

## Create a lb listener
resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.load-balancer.arn
  port              = "80"
  protocol          = "HTTP"
 
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }
}

resource "aws_key_pair" "project_keypair" {
  key_name   = "project_keypair"
  public_key = file(var.public_key)
}


resource "aws_instance" "instances" {
  ami           = "ami-00c6177f250e07ec1"
  instance_type = "t2.micro"
  key_name = "project_keypair"
  subnet_id = aws_subnet.public_subnets[count.index].id
  vpc_security_group_ids = [aws_security_group.project-sg.id]
  associate_public_ip_address = true
  count = 3

  tags = {
    Name = "WebServer"
  }
}

