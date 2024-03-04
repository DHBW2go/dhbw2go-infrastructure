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

    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "4.25.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = true
      recover_soft_deleted_secrets          = true
    }
  }

  skip_provider_registration = "true"

  tenant_id       = var.azure_tenant_id
  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "random_password" "RandomPassword" {
  length  = 16
  special = true
}
