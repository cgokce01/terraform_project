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
    count                   = 3 (var.cidr_block)

    tags = {
      name = "public_subnets"
    }
}

# CREATING PRIVATE SUBNETS
resource "aws_subnet" "private_subnets"{
    vpc_id              = aws_vpc.project-terraform.id
    cidr_block          = var.cidr[count.index]
    availability_zone   = var.az[count.index]
    count               = 3(var.cidr)
    tags = {
      name = "private_subnets"
    }
}


