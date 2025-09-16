data "azurerm_client_config" "current" {}

data "azuread_service_principal" "self" {
  object_id = data.azurerm_client_config.current.object_id
}

data "azurerm_monitor_diagnostic_categories" "fs" {
  resource_id = jsondecode(azurerm_resource_group_template_deployment.flexible_server.output_content).id.value
}

data "azurerm_monitor_diagnostic_categories" ec {
  resource_id = jsondecode(azurerm_resource_group_template_deployment.elastic_cluster.output_content).id.value
}