resource "azurerm_storage_account" "Azure-StorageAccount-DHBW2go" {
  name                     = "dhbw2go"
  resource_group_name      = azurerm_resource_group.Azure-ResourceGroup-Backend.name
  location                 = azurerm_resource_group.Azure-ResourceGroup-Backend.location

  account_tier             = "Standard"
  account_replication_type = "LRS"
}
