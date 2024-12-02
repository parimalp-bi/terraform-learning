terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.9"
    }
  }
}

provider azurerm {
  features {}
  subscription_id = "1f8c3888-4672-49d2-8e63-0b1b8819dba7"
}