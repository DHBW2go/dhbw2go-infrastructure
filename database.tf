resource "azurerm_mysql_flexible_server" "Azure-MySQL-FlexibleServer-DHBW2go" {
  name                   = "database-dhbw2go"
  resource_group_name    = azurerm_resource_group.Azure-ResourceGroup-Data.name
  location               = azurerm_resource_group.Azure-ResourceGroup-Data.location

  sku_name               = "B_Standard_B1s"

  administrator_login    = "DHBW2go"
  administrator_password = azurerm_key_vault_secret.Azure-KeyVault-DHBW2go-Secret-Database.value
}

resource "azurerm_mysql_flexible_server_firewall_rule" "Azure-MySQL-FlexibleServer-DHBW2go-AllowAll" {
  name                = "FirewallRule-AllowAll"
  resource_group_name = azurerm_resource_group.Azure-ResourceGroup-Data.name
  server_name         = azurerm_mysql_flexible_server.Azure-MySQL-FlexibleServer-DHBW2go.name

  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
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
  value   = azurerm_mysql_flexible_server.Azure-MySQL-FlexibleServer-DHBW2go.fqdn
}
