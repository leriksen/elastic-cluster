output id {
  value = jsondecode(azurerm_resource_group_template_deployment.elastic_cluster.output_content).id.value
}

output name {
  value = jsondecode(azurerm_resource_group_template_deployment.elastic_cluster.output_content).name.value
}