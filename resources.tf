data "azurerm_client_config" "Azure-ClientConfig-Current" {}

data "cloudflare_zone" "Cloudflare-Zone" {
  name = "dhbw2go.de"
}

resource "azurerm_resource_group" "Azure-ResourceGroup-Application" {
  name     = "dhbw2go-resources-application"
  location = "Germany West Central"
}

resource "azurerm_resource_group" "Azure-ResourceGroup-Data" {
  name     = "dhbw2go-resources-data"
  location = "Germany West Central"
}

resource "azurerm_resource_group" "Azure-ResourceGroup-Network" {
  name     = "dhbw2go-resources-network"
  location = "Germany West Central"
}
