resource "azurerm_mysql_flexible_server" "Database-DHBW2go" {
  name                   = "database-dhbw2go"
  resource_group_name    = azurerm_resource_group.ResourceGroup-Data.name
  location               = azurerm_resource_group.ResourceGroup-Data.location

  sku_name               = "B_Standard_B1s"

  administrator_login    = "DHBW2go"
  administrator_password = azurerm_key_vault_secret.Secret-Database.value
}
