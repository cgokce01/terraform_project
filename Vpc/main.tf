resource "aws_vpc" "project-terraform" {
  cidr_block =  var.vpc_cidr_block

tags = {
  name = "project-terraform"
}
}

 # CREATING PUBLIC SUBNETS
resource "aws_subnet" "public_subnets"{
    vpc_id                  = aws_vpc.project-terraform.id
    cidr_block              = var.cidr_block[count.index]
    availability_zone       = var.az[count.index]
    map_public_ip_on_launch = true
    count                   =  3

    tags = {
      name = "public_subnets"
    }
}

# CREATING PRIVATE SUBNETS
resource "aws_subnet" "private_subnets"{
    vpc_id              = aws_vpc.project-terraform.id
    cidr_block          = var.cidr[count.index]
    availability_zone   = var.az[count.index]
    count               = 3
    tags = {
      name = "private_subnets"
    }
}

# Create a internet-gateway
resource "aws_internet_gateway" "project-igw" {
  vpc_id = aws_vpc.project-terraform.id

  tags = {
    name = "project-igw"
  }
}

 # Create a route table for internet gateway
resource "aws_route_table" "project-rt" {
  vpc_id = aws_vpc.project-terraform.id
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project-igw.id
  }
  tags = {
    Name = "project-rt"
  }
}

 # Create a route table association for public subnets
resource "aws_route_table_association" "route-public_subnets" {
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.project-rt.id
  count = 3
}

# Create a elastic ip
resource "aws_eip" "project-eip" {
  vpc = true

  tags = {
    Name = "project-eip"
  }
}

 # Create a nat-gateway
resource "aws_nat_gateway" "project-nat-gateway" {
  allocation_id     = aws_eip.project-eip.id
  subnet_id         = aws_subnet.public_subnets[0].id
  depends_on        = [aws_internet_gateway.project-igw]
  
   tags = {
    Name = "project-nat-gateway"
  }
}

# Create a route table for nat gateway
resource "aws_route_table" "project-rt2" {
  vpc_id = aws_vpc.project-terraform.id
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.project-nat-gateway.id
  }
  tags = {
    Name = "project-rt2"
  }
}

 # Create a route table association for private subnets
resource "aws_route_table_association" "route-private_subnets" {
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.project-rt2.id
  count = 3
}

 # Create a security group
resource "aws_security_group" "project-sg" {
  name        = "project-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      =  aws_vpc.project-terraform.id
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
    ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "project-sg"
  }
}