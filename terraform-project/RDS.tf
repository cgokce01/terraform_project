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

resource "aws_rds_cluster" "db_instance" {
  cluster_identifier     = var.cluster_identifier
  engine                 = "aurora-mysql"
  availability_zones     = var.az
  database_name          = var.database_name
  master_username        = var.master_username
  master_password        = var.master_password
  vpc_security_group_ids = [aws_security_group.project-sg.id]
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.db-subnet-group.id
}

resource "aws_rds_cluster_instance" "reader_instances" {
  count              = 3
  identifier         = "reader-instances-${count.index}"
  cluster_identifier = aws_rds_cluster.db_instance.id
  instance_class     = "db.t3.medium"
  engine             = "aurora-mysql"
 db_subnet_group_name = aws_db_subnet_group.db-subnet-group.id
}

resource "aws_rds_cluster_instance" "writer_instance" {
  count              = 1
  identifier         = "writer-instance"
  cluster_identifier = aws_rds_cluster.db_instance.id
  instance_class     = "db.t3.medium"
  engine             = "aurora-mysql"
 db_subnet_group_name = aws_db_subnet_group.db-subnet-group.id

}

resource "aws_route53_record" "database_writer_endpoint" {
  zone_id = var.hosted-zone-id
  name    = "writer.${var.domain-name}"
  type    = "CNAME"
  ttl     = 300
  records = [ aws_lb.load-balancer.dns_name ]
}

resource "aws_route53_record" "database_reader_endpoint0" {
  zone_id = var.hosted-zone-id
  name    = "reader0.${var.domain-name}"
  type    = "CNAME"
  ttl     = 300
  records = [ aws_lb.load-balancer.dns_name ]
}

resource "aws_route53_record" "database_reader_endpoint1" {
  zone_id = var.hosted-zone-id
  name    = "reader1.${var.domain-name}"
  type    = "CNAME"
  ttl     = 300
  records = [ aws_lb.load-balancer.dns_name ]
}

resource "aws_route53_record" "database_reader_endpoint2" {
  zone_id = var.hosted-zone-id
  name    = "reader2.${var.domain-name}"
  type    = "CNAME"
  ttl     = 300
  records = [ aws_lb.load-balancer.dns_name ]
}