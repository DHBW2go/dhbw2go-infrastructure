resource "azurerm_storage_account" "StorageAccount-DHBW2go" {
  name                     = "dhbw2go"
  resource_group_name      = azurerm_resource_group.ResourceGroup-Data.name
  location                 = azurerm_resource_group.ResourceGroup-Data.location

  account_tier             = "Standard"
  account_replication_type = "LRS"
}
