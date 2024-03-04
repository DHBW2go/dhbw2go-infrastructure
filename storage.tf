variable "storage_name" {
  type = string
  default = "dhbw2go"
}

resource "azurerm_storage_account" "Azure-StorageAccount-DHBW2go" {
  name                     = var.storage_name
  resource_group_name      = azurerm_resource_group.Azure-ResourceGroup-Backend.name
  location                 = azurerm_resource_group.Azure-ResourceGroup-Backend.location

  account_tier             = "Standard"
  account_replication_type = "LRS"

  custom_domain {
    name = "storage.${data.cloudflare_zone.Cloudflare-Zone-DHBW2go.name}"
  }

  depends_on = [cloudflare_record.Cloudflare-Record-Storage-CNAME]
}

resource "cloudflare_record" "Cloudflare-Record-Storage-CNAME" {
  zone_id = data.cloudflare_zone.Cloudflare-Zone-DHBW2go.id

  type = "CNAME"

  name  = "storage"
  value = "${var.storage_name}.blob.core.windows.net"
}
