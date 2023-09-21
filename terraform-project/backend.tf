terraform {
  backend "s3" {
    bucket = "terraform-tfstate-cgokce01"
    key    = "path/to/my/key"
    region = "us-east-1"
    #dynamodb_table = "terraform-state"
  }
}