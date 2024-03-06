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

################################################################
#################### Custom Domain Binding #####################
################################################################

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

################################################################
####################### Role Assignment ########################
################################################################

resource "azurerm_role_assignment" "Azure-RoleAssignment-App-DHBW2go-Contributor-Backend" {
  scope              = azurerm_linux_web_app.Azure-App-DHBW2go.id
  role_definition_name = "Contributor"

  principal_id       = var.azure_service_principal_id_backend
  skip_service_principal_aad_check = true
}

################################################################
#################### KeyVault Access Policy ####################
################################################################

resource "azurerm_key_vault_access_policy" "Azure-KeyVault-DHBW2go-AccessPolicy-App" {
  key_vault_id = azurerm_key_vault.Azure-KeyVault-DHBW2go.id
  tenant_id    = data.azurerm_client_config.Azure-ClientConfig-Current.tenant_id
  object_id    = azurerm_linux_web_app.Azure-App-DHBW2go.identity[0].principal_id

  secret_permissions = [
    "Get"
  ]

  depends_on = [azurerm_linux_web_app.Azure-App-DHBW2go]
}

################################################################
################## Database Firewall Rule ######################
################################################################

resource "azurerm_mysql_flexible_server_firewall_rule" "Azure-MySQL-FlexibleServer-FirewallRule-DHBW2go-App" {
  foreach = toset(azurerm_linux_web_app.Azure-App-DHBW2go.outbound_ip_address_list)

  name                = "Allow-App-${index(keys(azurerm_linux_web_app.Azure-App-DHBW2go.outbound_ip_address_list), each.value)}"
  resource_group_name = azurerm_resource_group.Azure-ResourceGroup-Data.name
  server_name         = azurerm_mysql_flexible_server.Azure-MySQL-FlexibleServer-DHBW2go.name

  start_ip_address    = each.value
  end_ip_address      = each.value
}

################################################################
#################### GitHub Actions Variable ###################
################################################################

resource "github_actions_variable" "GitHub-Actions-Variable-Backend-AZURE_APP_NAME" {
  repository = var.github_repository_backend

  variable_name    = "AZURE_APP_NAME"
  value            = azurerm_linux_web_app.Azure-App-DHBW2go.name
}
