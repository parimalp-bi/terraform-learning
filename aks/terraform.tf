terraform {
  required_version = ">= 1.0"
  backend "local" {
    path = "/home/parimal/terraform-learning/terraform.tfstate"
  }
}