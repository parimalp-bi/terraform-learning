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
  subscription_id = ""
  resource_provider_registrations = "none"
  tenant_id = ""
  
}