
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
    interval            = 30
    protocol            = "HTTP"
    port                = 80
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = 200

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

# Key Pair created
resource "aws_key_pair" "project_keypair" {
  key_name   = "project_keypair"
  public_key = file(var.public_key)
}


# Create 3 instances with wordpress

resource "aws_instance" "WordPress" {
  ami           = "ami-00c6177f250e07ec1"
  instance_type = "t2.micro"
  key_name = "project_keypair"
  subnet_id = aws_subnet.public_subnets[0].id
  vpc_security_group_ids = [aws_security_group.project-sg.id]
  associate_public_ip_address = true

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
              sudo systemctl restart httpd
              EOF

  tags = {
    Name = "WordPress"
  }


    connection {
      type        = "ssh"
      user        = var.instance_username
      private_key = file(var.private_key)
      host        = aws_instance.WordPress.public_ip
  }

  }

# Target group attachment
resource "aws_lb_target_group_attachment" "tg-attachment" {
  target_group_arn = aws_lb_target_group.target-group.arn
  target_id        = aws_instance.WordPress.id
  port             = 80
}

# creating a launch template
resource "aws_launch_template" "launch_template" {

  name          = "launch_template"
  image_id      ="ami-00c6177f250e07ec1"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.project_keypair.id
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.project-sg.id]
  }
}

#Create a route 53
resource "aws_route53_record" "wordpress" {
  zone_id = var.hosted-zone-id
  name    = "wordpress.${var.domain-name}"
  type    = "CNAME"
  ttl     = 300
  records = [ aws_lb.load-balancer.dns_name ]
}
  
# create a file system
resource "aws_efs_file_system" "efs-project" {
  creation_token = "my-efs"

  tags = {
    Name = "efs-project"
  }
}

resource "aws_efs_mount_target" "mount-project" {
  file_system_id = aws_efs_file_system.efs-project.id
  subnet_id      = aws_subnet.public_subnets[0].id
}

resource "aws_autoscaling_group" "project-asg" {
  name                      = "project-asg"
  max_size                  = 99
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  target_group_arns   = [aws_lb_target_group.target-group.arn]
  vpc_zone_identifier       =  [aws_subnet.public_subnets[0].id, aws_subnet.public_subnets[1].id, aws_subnet.public_subnets[2].id]
    launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

    tag {
    key                 = "Name"
    value               = "asginstance"
    propagate_at_launch = true
  }

}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale_up"
  policy_type            = "SimpleScaling"
  autoscaling_group_name =aws_autoscaling_group.project-asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"   # add one instance
  cooldown               = "300" # cooldown period after scaling
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "asg-scale-down"
  autoscaling_group_name = aws_autoscaling_group.project-asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}
