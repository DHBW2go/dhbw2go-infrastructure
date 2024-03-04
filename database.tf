resource "azurerm_mysql_flexible_server" "Database-DHBW2go" {
  name                   = "database-dhbw2go"
  resource_group_name    = azurerm_resource_group.ResourceGroup-Data.name
  location               = azurerm_resource_group.ResourceGroup-Data.location

  sku_name               = "B_Standard_B1s"

  administrator_login    = "DHBW2go"
  administrator_password = azurerm_key_vault_secret.Secret-Database.value
}

resource "azurerm_mysql_flexible_server_firewall_rule" "FirewallRule-Database" {
  name                = "FirewallRule-AllowAll"
  resource_group_name = azurerm_resource_group.ResourceGroup-Data.name
  server_name         = azurerm_mysql_flexible_server.Database-DHBW2go.name

  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}

resource "cloudflare_record" "Record-CNAME-Database" {
  zone_id = data.cloudflare_zone.Zone-DHBW2go.id

  type    = "CNAME"

  name    = "database"
  value   = azurerm_mysql_flexible_server.Database-DHBW2go.fqdn
}
