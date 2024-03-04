resource "azurerm_resource_group" "Group-Backend" {
  name     = "rg-backend"
  location = "Germany West Central"
}

resource "azurerm_resource_group" "Group-Store" {
  name     = "rg-store"
  location = "Germany West Central"
}
