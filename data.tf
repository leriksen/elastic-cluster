data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = azurerm_resource_group.psql_fs_ec.name
}

#
# data "azuread_service_principal" "self" {
#   object_id = data.azurerm_client_config.current.object_id
# }
#
# data "azuread_group" "pg_admins" {
#   display_name     = "pg_admins"
#   security_enabled = true
# }

data "azuread_service_principal" "self" {
  object_id = data.azurerm_client_config.current.object_id
}