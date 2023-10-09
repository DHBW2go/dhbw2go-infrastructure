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

  cloud {
    token = var.TF_API_TOKEN
    organization = var.TF_CLOUD_ORGANIZATION
    workspaces {
      name = var.TF_WORKSPACE
    }
  }
}

provider "azurerm" {
  features {}
}