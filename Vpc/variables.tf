variable "region" {
  description = "please provide a region information"
  type        = string
  default     = "us-east-1"
}

variable "cidr_block" {
  description = "please provide a cidr_block information"
  type        = string
  default     = "10.0.0.0/16"
}
variable "vpc_id" {
  type = string
  default = aws_vpc.project-terraform
}

variable "vpc_public_subnets" {
  description = "List of public subnet CIDR ranges"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "vpc_private_subnets" {
  description = "List of public subnet CIDR ranges"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}


variable "availability_zones" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}