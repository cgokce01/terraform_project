resource "aws_vpc" "project-terraform" {
  cidr_block = var.cidr_block

tags = {
  name = "project-terraform"
}
}

resource "aws_subnet" "public_subnet1"{
    vpc_id = "${var.vpc_id}".id
     availability_zone       = "${var.region}a"
    cidr_block = var.public_subnet1
    map_public_ip_on_launch = true

    tags = {
      name = "public_subnet1"
    }
}

resource "aws_subnet" "public_subnet2"{
    vpc_id = "${var.vpc_id}".id
     availability_zone       = "${var.region}b"
    cidr_block = var.public_subnet2
    map_public_ip_on_launch = true

    tags = {
      name = "public_subnet2"
    }
}

resource "aws_subnet" "public_subnet3"{
    vpc_id = aws_vpc.project-terraform.id
     availability_zone       = "${var.region}c"
    cidr_block = var.public_subnet3
    map_public_ip_on_launch = true

    tags = {
      name = "public_subnet3"
    }
}



resource "aws_subnet" "private_subnet1"{
    vpc_id = aws_vpc.project-terraform.id
    cidr_block = var.private_subnet1
    availability_zone =  "${var.region}a"
    
    tags = {
      name = "private_subnet2"
    }

   }
   resource "aws_subnet" "private_subnet2"{
    vpc_id = aws_vpc.project-terraform.id
    cidr_block = var.private_subnet2
    availability_zone =  "${var.region}b"
   
    tags = {
      name = "private_subnet2"
    }

}

resource "aws_subnet" "private_subnet3" {
 vpc_id       = aws_vpc.project-terraform.id
  cidr_block              = var.private_subnet3
  availability_zone       = "${var.region}c"
  
  tags = {
    Name = "private_subnet3"
  }
}


 # Create a internet-gateway
resource "aws_internet_gateway" "project-igw" {
  vpc_id = aws_vpc.project-terraform.id

  tags = {
    name = "project-igw"
  }
}

 # Create a route table internet gateway
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

 # Create a route table association 
resource "aws_route_table_association" "route-public_subnet1" {
  subnet_id      =  aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.project-rt.id
}

resource "aws_route_table_association" "route-public_subnet2" {
  subnet_id      =  aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.project-rt.id
}

resource "aws_route_table_association" "route-public_subnet3" {
  subnet_id      = aws_subnet.public_subnet3.id
  route_table_id = aws_route_table.project-rt.id
}

 # Create a nat-gateway
resource "aws_nat_gateway" "project-nat-gateway" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.private_subnet1.id

   tags = {
    Name = "project-nat-gateway"
  }
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