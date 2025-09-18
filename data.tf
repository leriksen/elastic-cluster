data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

data "azuread_service_principal" "self" {
  object_id = data.azurerm_client_config.current.object_id
}
