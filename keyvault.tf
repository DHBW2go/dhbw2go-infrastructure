resource "azurerm_key_vault" "DHBW2go" {
  name                        = "keyvault-dhbw2go"
  location                    = azurerm_resource_group.Data.location
  resource_group_name         = azurerm_resource_group.Data.name
  tenant_id                   = data.azurerm_client_config.ClientConfig.tenant_id

  sku_name                    = "standard"
}

resource "azurerm_key_vault_secret" "Database" {
  name         = "secret-database"
  key_vault_id = azurerm_key_vault.DHBW2go.id

  value        = random_password.Database.result
}
