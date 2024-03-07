resource "azurerm_mysql_flexible_server" "Azure-MySQL-FlexibleServer" {
  name                   = "dhbw2go-database"
  resource_group_name    = azurerm_resource_group.Azure-ResourceGroup-Data.name
  location               = azurerm_resource_group.Azure-ResourceGroup-Data.location

  sku_name               = "B_Standard_B1s"

  delegated_subnet_id    = azurerm_subnet.Azure-Subnet-Database.id
  private_dns_zone_id    = azurerm_private_dns_zone.Azure-PrivateDNSZone-Database.id

  administrator_login    = "DHBW2go"
  administrator_password = azurerm_key_vault_secret.Azure-KeyVault-Secret-Database.value

  zone = 3

  depends_on = [azurerm_private_dns_zone_virtual_network_link.Azure-PrivateDNSZone-NetworkLink-Database]
}

resource "azurerm_mysql_flexible_database" "Azure-MySQL-FlexibleServer-Database-Backend" {
  name                = "backend"
  resource_group_name = azurerm_resource_group.Azure-ResourceGroup-Data.name
  server_name         = azurerm_mysql_flexible_server.Azure-MySQL-FlexibleServer.name

  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

################################################################
############################# Subnet ###########################
################################################################

resource "azurerm_subnet" "Azure-Subnet-Database" {
  name                 = "dhbw2go-subnet-database"
  resource_group_name  = azurerm_resource_group.Azure-ResourceGroup-Network.name
  virtual_network_name = azurerm_virtual_network.Azure-VirtualNetwork.name

  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Storage"]

  delegation {
    name = "dhbw2go-delegation-database"
    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_private_dns_zone" "Azure-PrivateDNSZone-Database" {
  name                = "private.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.Azure-ResourceGroup-Network.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "Azure-PrivateDNSZone-NetworkLink-Database" {
  name                  = "dhbw2go-link-database"
  resource_group_name   = azurerm_resource_group.Azure-ResourceGroup-Network.name
  virtual_network_id    = azurerm_virtual_network.Azure-VirtualNetwork.id
  private_dns_zone_name = azurerm_private_dns_zone.Azure-PrivateDNSZone-Database.name
}

################################################################
####################### Key Vault Secret #######################
################################################################

resource "random_password" "RandomPassword-Database" {
  length  = 16
  special = true
}


resource "azurerm_key_vault_secret" "Azure-KeyVault-Secret-Database" {
  name         = "dhbw2go-secret-database"
  key_vault_id = azurerm_key_vault.Azure-KeyVault.id

  value        = random_password.RandomPassword-Database.result

  depends_on = [azurerm_key_vault_access_policy.Azure-KeyVault-AccessPolicy-Secret]
}

