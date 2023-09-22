variable "region" {
  description = "please provide a region information"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "please provide a CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}


variable "cidr_block" {
  description = "please provide a cidr_block for public subnets"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24", ]
}

variable "cidr" {
  description = "please provide a cidr_block for the private subnets"
  type        = list(string)
  default     = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]
}


variable "az" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c", ]
}

variable "ami_id" {
  description = "AMI ID for the instances"
  default     = "ami-00c6177f250e07ec1"
}
