resource "azurerm_service_plan" "Azure-ServicePlan-DHBW2go" {
  name                = "serviceplan-dhbw2go"
  resource_group_name = azurerm_resource_group.Azure-ResourceGroup-Backend.name
  location            = azurerm_resource_group.Azure-ResourceGroup-Backend.location
  os_type             = "Linux"
  sku_name            = "B1"
}


resource "azurerm_linux_web_app" "Azure-App-DHBW2go" {
  name                = "app-dhbw2go"
  resource_group_name = azurerm_resource_group.Azure-ResourceGroup-Backend.name
  location            = azurerm_service_plan.Azure-ServicePlan-DHBW2go.location
  service_plan_id     = azurerm_service_plan.Azure-ServicePlan-DHBW2go.id

  site_config {}

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "MYSQL_HOSTNAME" = cloudflare_record.Cloudflare-Record-Database-CNAME.hostname
    "MYSQL_PORT"     = "3306"
    "MYSQL_DATABASE" = azurerm_mysql_flexible_database.Azure-MySQL-FlexibleServer-DHBW2go-Database-Backend.name
    "MYSQL_USERNAME" = azurerm_mysql_flexible_server.Azure-MySQL-FlexibleServer-DHBW2go.administrator_login
    "MYSQL_PASSWORD" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.Azure-KeyVault-DHBW2go-Secret-Database.versionless_id})"

  }
}

resource "azurerm_key_vault_access_policy" "Azure-KeyVault-DHBW2go-AccessPolicy-App" {
  key_vault_id = azurerm_key_vault.Azure-KeyVault-DHBW2go.id
  tenant_id    = data.azurerm_client_config.Azure-ClientConfig-Current.tenant_id
  object_id    = azurerm_linux_web_app.Azure-App-DHBW2go.identity[0].principal_id

  secret_permissions = [
    "Get"
  ]

  depends_on = [azurerm_linux_web_app.Azure-App-DHBW2go]
}


resource "azurerm_app_service_custom_hostname_binding" "Azure-App-DHBW2go-CustomHostnameBinding" {
  hostname            = "api.${data.cloudflare_zone.Cloudflare-Zone-DHBW2go.name}"
  resource_group_name = azurerm_resource_group.Azure-ResourceGroup-Backend.name
  app_service_name    = azurerm_linux_web_app.Azure-App-DHBW2go.name

  depends_on = [cloudflare_record.Cloudflare-Record-API-CNAME]
}

resource "azurerm_app_service_managed_certificate" "Azure-App-DHBW2go-Certificate" {
  custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.Azure-App-DHBW2go-CustomHostnameBinding.id
}

resource "azurerm_app_service_certificate_binding" "Azure-App-DHBW2go-CertificateBinding" {
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.Azure-App-DHBW2go-CustomHostnameBinding.id
  certificate_id      = azurerm_app_service_managed_certificate.Azure-App-DHBW2go-Certificate.id

  ssl_state           = "SniEnabled"
}

resource "cloudflare_record" "Cloudflare-Record-API-CNAME" {
  zone_id = data.cloudflare_zone.Cloudflare-Zone-DHBW2go.id

  type    = "CNAME"

  name    = "api"
  value   = azurerm_linux_web_app.Azure-App-DHBW2go.default_hostname

  depends_on = [cloudflare_record.Cloudflare-Record-API-TXT]
}

resource "cloudflare_record" "Cloudflare-Record-API-TXT" {
  zone_id = data.cloudflare_zone.Cloudflare-Zone-DHBW2go.id

  type    = "TXT"

  name    = "asuid.api"
  value   = azurerm_linux_web_app.Azure-App-DHBW2go.custom_domain_verification_id
}
