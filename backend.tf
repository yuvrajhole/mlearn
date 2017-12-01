terraform {
  backend "s3" {
    bucket = "hdfclife-tfstat"
    key    = "M-Learn/terraform.tfstate"
    region = "ap-south-1"
  }
}
