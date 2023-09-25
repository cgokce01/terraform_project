resource "aws_db_subnet_group" "db-subnet-group" {
  name       = "main"
  subnet_ids = [aws_subnet.private_subnets[0].id, aws_subnet.private_subnets[1].id, aws_subnet.private_subnets[2].id]
}

resource "aws_security_group" "database_sg" {
  name        = "database-sg"
  vpc_id      = aws_vpc.project-terraform.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}