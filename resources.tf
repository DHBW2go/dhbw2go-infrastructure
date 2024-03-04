data "azurerm_client_config" "ClientConfig" {}

resource "azurerm_resource_group" "ResourceGroup-Backend" {
  name     = "Resources-dhbw2go-backend"
  location = "Germany West Central"
}

resource "azurerm_resource_group" "ResourceGroup-Data" {
  name     = "resources-dhbw2go-data"
  location = "Germany West Central"
}
