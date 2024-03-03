terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.94.0"
    }
    ionoscloud = {
      source  = "ionos-cloud/ionoscloud"
      version = "6.4.13"
    }
  }
}

provider "azurerm" {
  features {}
}
