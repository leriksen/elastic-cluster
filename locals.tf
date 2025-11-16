locals {
  server_id = format("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.DBforPostgreSQL/flexibleServers/%s", data.azurerm_subscription.current.subscription_id, data.azurerm_resource_group.rg.name, local.psql_name)
}