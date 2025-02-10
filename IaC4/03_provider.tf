terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.18.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "67a9f948-c9a9-44d4-a95a-117efacfd19c"
  features {}
}