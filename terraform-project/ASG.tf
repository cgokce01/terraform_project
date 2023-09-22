
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

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd php php-mysqlnd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
              cd /var/www/html
              sudo wget https://wordpress.org/latest.tar.gz
              sudo tar -xzf latest.tar.gz
              sudo cp -R wordpress/* /var/www/html/
              sudo chown -R apache:apache /var/www/html/
              sudo mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
              sudo systemctl restart httpd
              EOF

  tags = {
    Name = "WordPress"
  }
}



  


