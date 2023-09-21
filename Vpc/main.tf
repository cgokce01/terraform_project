resource "aws_vpc" "project-terraform" {
  cidr_block =  "10.0.0.0/16"

tags = {
  name = "project-terraform"
}
}

 # CREATING PUBLIC SUBNETS
resource "aws_subnet" "vpc_subnets"{
    vpc_id                  = aws_vpc.project-terraform.id
    cidr_block              = var.cidr_block[count.index]
    availability_zone       = var.az[count.index]
    map_public_ip_on_launch = true
    count                   = 6

    tags = {
      name = "vpc_subnets"
    }
}



