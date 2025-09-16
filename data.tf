data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

data "azuread_service_principal" "self" {
  object_id = data.azurerm_client_config.current.object_id
}

data azurerm_postgresql_flexible_server fs {
  depends_on = [
    azurerm_resource_group_template_deployment.flexible_server
  ]
  resource_group_name = azurerm_resource_group.rg.name
  name = local.fs_name
}

data azurerm_postgresql_flexible_server ec {
  depends_on = [
    azurerm_resource_group_template_deployment.elastic_cluster
  ]
  resource_group_name = azurerm_resource_group.rg.name
  name = local.ec_name
}

data "azurerm_monitor_diagnostic_categories" "fs" {
  resource_id = data.azurerm_postgresql_flexible_server.fs.id
}

data "azurerm_monitor_diagnostic_categories" ec {
  resource_id = data.azurerm_postgresql_flexible_server.ec.id
}