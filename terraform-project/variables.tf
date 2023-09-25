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

variable "public_key" {
  description = "public key location"
  type        = string
  default     = "/home/ec2-user/.ssh/id_rsa.pub"
}

variable "private_key" {
  description = "private key location"
  type        = string
  default     = "/home/ec2-user/.ssh/id_rsa"
}

variable "instance_username" {
  description = "user to ssh to remote host"
  type        = string
  default     = "ec2-user"
}

variable "hosted-zone-id" {
  description = "provide the zone id"
  type = string
  default = "Z0835897267AK4RJ42B1S"
  
}
variable "domain-name" {
  description = "provide the  doamin name"
  type = string
  default = "cabinetladystudio.com"
}

variable "cluster_identifier" {
  description = "Provide the cluster identifier for database"
  type = string
  default = "mydatabase1"
  
}

variable "database_name" {
  description = "name of rds database"
  type = string
  default = "my_database"
  
}

variable "master_username" {
  description = "Provide the username"
  type = string
  default = "team1"
}

variable "master_password" {
  description = "provide password for master username"
  type = string
  default = "ohyeswedidit:)"
  
}