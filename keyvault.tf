resource "azurerm_key_vault" "KeyVault-DHBW2go" {
  name                        = "keyvault-dhbw2go"
  location                    = azurerm_resource_group.ResourceGroup-Data.location
  resource_group_name         = azurerm_resource_group.ResourceGroup-Data.name
  tenant_id                   = data.azurerm_client_config.ClientConfig

  sku_name                    = "standard"
}

resource "azurerm_key_vault_secret" "Secret-Database" {
  name         = "secret-database"
  key_vault_id = azurerm_key_vault.KeyVault-DHBW2go.id

  value        = random_password.RandomPassword.result
}
