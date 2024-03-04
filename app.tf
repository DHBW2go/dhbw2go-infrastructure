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
