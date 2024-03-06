data "azurerm_client_config" "Azure-ClientConfig-Current" {}

data "cloudflare_zone" "Cloudflare-Zone" {
  name = "dhbw2go.de"
}

resource "azurerm_resource_group" "Azure-ResourceGroup-Backend" {
  name     = "resources-dhbw2go-backend"
  location = "Germany West Central"
}

resource "azurerm_resource_group" "Azure-ResourceGroup-Data" {
  name     = "resources-dhbw2go-data"
  location = "Germany West Central"
}

resource "azurerm_resource_group" "Azure-ResourceGroup-Network" {
  name     = "resources-dhbw2go-data"
  location = "Germany West Central"
}
