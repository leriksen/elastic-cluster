data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

data "azuread_service_principal" "self" {
  object_id = data.azurerm_client_config.current.object_id
}

data azurerm_postgresql_flexible_server postgres {
  depends_on = [
    azurerm_resource_group_template_deployment.postgres
  ]
  resource_group_name = var.rg_name
  name = local.psql_name
}

data azurerm_postgresql_flexible_server replica {
  depends_on = [
    azurerm_resource_group_template_deployment.replica
  ]
  resource_group_name = var.rg_name
  name = local.psql_replica_name
}

data "azurerm_monitor_diagnostic_categories" "psql" {
  resource_id = data.azurerm_postgresql_flexible_server.postgres.id
}

data "azurerm_monitor_diagnostic_categories" "replica" {
  resource_id = data.azurerm_postgresql_flexible_server.replica.id
}
