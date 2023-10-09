terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.75.0"
    }
    ionoscloud = {
      source = "ionos-cloud/ionoscloud"
      version = "6.4.9"
    }
    github = {
      source = "integrations/github"
      version = "5.39.0"
    }
  }
}

provider "azurerm" {
  features {}
}