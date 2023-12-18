terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.76.0"
    }
    ionoscloud = {
      source  = "ionos-cloud/ionoscloud"
      version = "6.4.11"
    }
    github = {
      source  = "integrations/github"
      version = "5.40.0"
    }
  }

  cloud {}
}

provider "azurerm" {
  features {}
}