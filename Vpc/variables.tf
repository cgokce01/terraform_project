variable "region" {
  description = "please provide a region information"
  type        = string
  default     = "us-east-1"
}

variable "cidr_block" {
  description = "please provide a cidr_block information"
  type        = list(string)
  default     = ["10.0.7.0/24", "10.0.8.0/24","10.0.9.0/24"
                 "10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"  ]
}


variable "az" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}


