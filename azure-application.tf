resource "azurerm_service_plan" "Azure-ServicePlan" {
  name                = "dhbw2go-appserviceplan"
  resource_group_name = azurerm_resource_group.Azure-ResourceGroup-Application.name
  location            = azurerm_resource_group.Azure-ResourceGroup-Application.location

  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "Azure-LinuxWebApp" {
  name                = "dhbw2go-appservice"
  resource_group_name = azurerm_resource_group.Azure-ResourceGroup-Application.name
  location            = azurerm_service_plan.Azure-ServicePlan.location
  service_plan_id     = azurerm_service_plan.Azure-ServicePlan.id

  site_config {}

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "MYSQL_HOSTNAME" = cloudflare_record.Cloudflare-Record-CNAME-Database.hostname
    "MYSQL_PORT"     = "3306"
    "MYSQL_DATABASE" = azurerm_mysql_flexible_database.Azure-MySQL-FlexibleServer-Database-Backend.name
    "MYSQL_USERNAME" = azurerm_mysql_flexible_server.Azure-MySQL-FlexibleServer.administrator_login
    "MYSQL_PASSWORD" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.Azure-KeyVault-Secret-Database.versionless_id})"

  }
}

################################################################
######################## Custom Domain #########################
################################################################

resource "azurerm_app_service_custom_hostname_binding" "Azure-AppService-CustomHostnameBinding" {
  hostname            = "api.${data.cloudflare_zone.Cloudflare-Zone.name}"
  resource_group_name = azurerm_resource_group.Azure-ResourceGroup-Application.name
  app_service_name    = azurerm_linux_web_app.Azure-LinuxWebApp.name

  depends_on = [cloudflare_record.Cloudflare-Record-CNAME-Application]
}

resource "azurerm_app_service_managed_certificate" "Azure-AppService-ManagedCertificate" {
  custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.Azure-AppService-CustomHostnameBinding.id
}

resource "azurerm_app_service_certificate_binding" "Azure-AppService-CertificateBinding" {
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.Azure-AppService-CustomHostnameBinding.id
  certificate_id      = azurerm_app_service_managed_certificate.Azure-AppService-ManagedCertificate.id

  ssl_state           = "SniEnabled"
}

resource "cloudflare_record" "Cloudflare-Record-CNAME-Application" {
  zone_id = data.cloudflare_zone.Cloudflare-Zone.id

  type    = "CNAME"

  name    = "api"
  value   = azurerm_linux_web_app.Azure-LinuxWebApp.default_hostname

  depends_on = [cloudflare_record.Cloudflare-Record-TXT-Application]
}

resource "cloudflare_record" "Cloudflare-Record-TXT-Application" {
  zone_id = data.cloudflare_zone.Cloudflare-Zone.id

  type    = "TXT"

  name    = "asuid.api"
  value   = azurerm_linux_web_app.Azure-LinuxWebApp.custom_domain_verification_id
}

################################################################
####################### Key Vault Access #######################
################################################################

resource "azurerm_key_vault_access_policy" "Azure-KeyVault-AccessPolicy-Application" {
  key_vault_id = azurerm_key_vault.Azure-KeyVault.id
  tenant_id    = data.azurerm_client_config.Azure-ClientConfig-Current.tenant_id
  object_id    = azurerm_linux_web_app.Azure-LinuxWebApp.identity[0].principal_id

  secret_permissions = [
    "Get"
  ]

  depends_on = [azurerm_linux_web_app.Azure-LinuxWebApp]
}

################################################################
######################### GitHub Actions #######################
################################################################

resource "azurerm_role_assignment" "Azure-RoleAssignment-Contributor-Application" {
  scope              = azurerm_linux_web_app.Azure-LinuxWebApp.id
  role_definition_name = "Contributor"

  principal_id       = var.azure_service_principal_id_backend
  skip_service_principal_aad_check = true
}

resource "github_actions_variable" "GitHub-Actions-Variable-AZURE_APP_NAME" {
  repository = var.github_repository_backend

  variable_name    = "AZURE_APP_NAME"
  value            = azurerm_linux_web_app.Azure-LinuxWebApp.name
}
