data "azurerm_client_config" "Current" {}

data "cloudflare_zone" "DHBW2go" {
  name = "dhbw2go.de"
}

resource "azurerm_resource_group" "Backend" {
  name     = "resources-dhbw2go-backend"
  location = "Germany West Central"
}

resource "azurerm_resource_group" "Data" {
  name     = "resources-dhbw2go-data"
  location = "Germany West Central"
}
