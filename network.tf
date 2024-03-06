resource "azurerm_virtual_network" "Azure-VirtualNetwork" {
  name                = "dhbw2go-virtualnetwork"
  location            = azurerm_resource_group.Azure-ResourceGroup-Network.location
  resource_group_name = azurerm_resource_group.Azure-ResourceGroup-Network.name

  address_space       = ["10.0.0.0/24"]
}
