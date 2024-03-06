resource "azurerm_key_vault" "Azure-KeyVault" {
  name                        = "dhbw2go-keyvault"
  location                    = azurerm_resource_group.Azure-ResourceGroup-Data.location
  resource_group_name         = azurerm_resource_group.Azure-ResourceGroup-Data.name
  tenant_id                   = data.azurerm_client_config.Azure-ClientConfig-Current.tenant_id

  sku_name                    = "standard"
}

resource "azurerm_key_vault_access_policy" "Azure-KeyVault-AccessPolicy-Secret" {
  key_vault_id       = azurerm_key_vault.Azure-KeyVault.id
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
