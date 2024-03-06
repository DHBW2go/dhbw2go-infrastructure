variable "database_name" {
  type = string
  default = "dhbw2go-database"
}

resource "azurerm_mysql_flexible_server" "Azure-MySQL-FlexibleServer" {
  name                   = var.database_name
  resource_group_name    = azurerm_resource_group.Azure-ResourceGroup-Data.name
  location               = azurerm_resource_group.Azure-ResourceGroup-Data.location

  sku_name               = "B_Standard_B1s"

  administrator_login    = "DHBW2go"
  administrator_password = azurerm_key_vault_secret.Azure-KeyVault-Secret-Database.value

  zone = 3

  depends_on = [cloudflare_record.Cloudflare-Record-CNAME-Database]
}

resource "azurerm_mysql_flexible_database" "Azure-MySQL-FlexibleServer-Database-Backend" {
  name                = "backend"
  resource_group_name = azurerm_resource_group.Azure-ResourceGroup-Data.name
  server_name         = azurerm_mysql_flexible_server.Azure-MySQL-FlexibleServer.name

  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

################################################################
######################## Custom Domain #########################
################################################################

resource "cloudflare_record" "Cloudflare-Record-CNAME-Database" {
  zone_id = data.cloudflare_zone.Cloudflare-Zone.id

  type    = "CNAME"

  name    = "database"
  value   = "${var.database_name}.mysql.database.azure.com"
}

################################################################
####################### Key Vault Secret #######################
################################################################

resource "azurerm_key_vault_secret" "Azure-KeyVault-Secret-Database" {
  name         = "dhbw2go-secret-database"
  key_vault_id = azurerm_key_vault.Azure-KeyVault.id

  value        = random_password.RandomPassword-Database.result

  depends_on = [azurerm_key_vault_access_policy.Azure-KeyVault-AccessPolicy-Secret]
}

