output highAvailability {
  value = jsondecode(azurerm_resource_group_template_deployment.elastic_cluster.output_content).highAvailability.value
}