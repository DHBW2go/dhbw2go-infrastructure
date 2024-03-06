variable "database_name" {
  type = string
  default = "database-dhbw2go"
}

resource "azurerm_mysql_flexible_server" "Azure-MySQL-FlexibleServer-DHBW2go" {
  name                   = var.database_name
  resource_group_name    = azurerm_resource_group.Azure-ResourceGroup-Data.name
  location               = azurerm_resource_group.Azure-ResourceGroup-Data.location

  sku_name               = "B_Standard_B1s"

  administrator_login    = "DHBW2go"
  administrator_password = azurerm_key_vault_secret.Azure-KeyVault-DHBW2go-Secret-Database.value

  zone = 3

  depends_on = [cloudflare_record.Cloudflare-Record-Database-CNAME]
}

resource "azurerm_mysql_flexible_database" "Azure-MySQL-FlexibleServer-DHBW2go-Database-Backend" {
  name                = "backend"
  resource_group_name = azurerm_resource_group.Azure-ResourceGroup-Data.name
  server_name         = azurerm_mysql_flexible_server.Azure-MySQL-FlexibleServer-DHBW2go.name

  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "cloudflare_record" "Cloudflare-Record-Database-CNAME" {
  zone_id = data.cloudflare_zone.Cloudflare-Zone-DHBW2go.id

  type    = "CNAME"

  name    = "database"
  value   = "${var.database_name}.mysql.database.azure.com"
}
