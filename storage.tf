variable "storage_name" {
  type = string
  default = "dhbw2go"
}

resource "azurerm_storage_account" "Azure-StorageAccount" {
  name                     = var.storage_name
  resource_group_name      = azurerm_resource_group.Azure-ResourceGroup-Data.name
  location                 = azurerm_resource_group.Azure-ResourceGroup-Data.location

  account_tier             = "Standard"
  account_replication_type = "LRS"

  custom_domain {
    name = "storage.${data.cloudflare_zone.Cloudflare-Zone.name}"
  }

  depends_on = [cloudflare_record.Cloudflare-Record-CNAME-Storage]
}

################################################################
######################## Custom Domain #########################
################################################################

resource "cloudflare_record" "Cloudflare-Record-CNAME-Storage" {
  zone_id = data.cloudflare_zone.Cloudflare-Zone.id

  type = "CNAME"

  name  = "storage"
  value = "${var.storage_name}.blob.core.windows.net"
}
