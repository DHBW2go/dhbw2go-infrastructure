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
