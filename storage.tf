resource "azurerm_storage_account" "Azure-StorageAccount-DHBW2go" {
  name                     = "dhbw2go"
  resource_group_name      = azurerm_resource_group.Azure-ResourceGroup-Backend.name
  location                 = azurerm_resource_group.Azure-ResourceGroup-Backend.location

  account_tier             = "Standard"
  account_replication_type = "LRS"

  custom_domain {
    name = cloudflare_record.Cloudflare-Record-Storage-CNAME.hostname
  }

  depends_on = [cloudflare_record.Cloudflare-Record-Storage-CNAME]
}

resource "cloudflare_record" "Cloudflare-Record-Storage-CNAME" {
  zone_id = data.cloudflare_zone.Cloudflare-Zone-DHBW2go.id

  type = "CNAME"

  name  = "storage"
  value = "${azurerm_storage_account.Azure-StorageAccount-DHBW2go.name}.blob.core.windows.net"
}
