resource "azurerm_key_vault" "Azure-KeyVault-DHBW2go" {
  name                        = "keyvault-dhbw2go"
  location                    = azurerm_resource_group.Azure-ResourceGroup-Data.location
  resource_group_name         = azurerm_resource_group.Azure-ResourceGroup-Data.name
  tenant_id                   = data.azurerm_client_config.Azure-ClientConfig-Current.tenant_id

  sku_name                    = "standard"
}

resource "azurerm_key_vault_access_policy" "Azure-KeyVault-DHBW2go-AccessPolicy-AllowAll" {
  key_vault_id       = azurerm_key_vault.Azure-KeyVault-DHBW2go.id
  tenant_id          = data.azurerm_client_config.Azure-ClientConfig-Current.tenant_id
  object_id          = data.azurerm_client_config.Azure-ClientConfig-Current.object_id

  secret_permissions = [
    "Set",
    "Get",
    "Delete",
    "Purge",
    "Recover"
  ]
}

resource "azurerm_key_vault_secret" "Azure-KeyVault-DHBW2go-Secret-Database" {
  name         = "secret-database"
  key_vault_id = azurerm_key_vault.Azure-KeyVault-DHBW2go.id

  value        = random_password.RandomPassword-Database.result

  depends_on = [azurerm_key_vault_access_policy.Azure-KeyVault-DHBW2go-AccessPolicy-AllowAll]
}
