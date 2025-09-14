# resource "azurerm_resource_group_template_deployment" "elastic_cluster" {
#   depends_on = [
#     azurerm_role_assignment.secret_reader
#   ]
#   deployment_mode     = "Incremental"
#   name                = format("%s-ec-%s", local.psql_name, formatdate("YYYYMMDDhhmmss", timestamp()))
#   template_content    = file("${path.module}/templates/arm_elastic_cluster.json")
#   resource_group_name = data.azurerm_resource_group.rg.name
#   parameters_content = jsonencode({
#     active_directory_auth = {
#       value = module.global.active_directory_auth
#     }
#     availability_zone = {
#       value = module.global.availability_zone
#     }
#     backup_retention_days = {
#       value = module.global.backup_retention_days
#     }
#     cluster_size = {
#       value = module.global.cluster_size
#     }
#     cmk_assigned_identity = {
#       value = azurerm_user_assigned_identity.umi.principal_id
#     }
#     cmk_key_uri = {
#       value = azurerm_key_vault_key.cmk.resource_versionless_id
#     }
#     geo_redundant_backup = {
#       value = module.global.geo_redundant_backup
#     }
#     ha_mode = {
#       value = module.global.ha_mode
#     }
#     location = {
#       value = data.azurerm_resource_group.rg.location
#     }
#     name = {
#       value = format("%s-pgfsec-0%s", data.azurerm_resource_group.rg.name, var.index)
#     }
#     password_auth = {
#       value = module.global.password_auth
#     }
#     sku_name = {
#       value = module.global.ec_sku_name
#     }
#     sku_tier = {
#       value = module.global.sku_tier
#     }
#     standby_availability_zone = {
#       value = module.global.standby_availability_zone
#     }
#     storage_autogrow = {
#       value = module.global.storage_autogrow
#     }
#     storage_size_gb = {
#       value = module.global.storage_size_gb
#     }
#     tenant_id = {
#       value = data.azurerm_client_config.current.tenant_id
#     }
#     version = {
#       value = module.global.pg_version
#     }
#   })
# }
#
# resource "azurerm_storage_account" "sa" {
#   name                     = "lepostgresqllogs"
#   resource_group_name      = data.azurerm_resource_group.rg.name
#   location                 = data.azurerm_resource_group.rg.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }
# #
# # resource "azurerm_monitor_diagnostic_setting" "logging" {
# #   name               = "logging"
# #   target_resource_id = jsondecode(azurerm_resource_group_template_deployment.elastic_cluster.output_content).id.value
# #   storage_account_id = azurerm_storage_account.sa.id
# #   enabled_log {}
# #   enabled_metric {
# #    category = "AllMetrics"
# #  }
# # }
#
# resource "azurerm_postgresql_flexible_server_active_directory_administrator" "aad" {
#   object_id           = data.azurerm_client_config.current.object_id
#   principal_name      = data.azuread_service_principal.self.display_name
#   principal_type      = "ServicePrincipal"
#   resource_group_name = data.azurerm_resource_group.rg.name
#   server_name         = lookup(jsondecode(azurerm_resource_group_template_deployment.elastic_cluster.output_content).name, "value")
#   tenant_id           = data.azurerm_client_config.current.tenant_id
# }
#
# resource "azurerm_postgresql_flexible_server_configuration" "config" {
#   for_each  = module.global.server_configs
#   name      = each.key
#   server_id = lookup(jsondecode(azurerm_resource_group_template_deployment.elastic_cluster.output_content).id, "value")
#   value     = each.value
# }
#
# resource "azurerm_postgresql_flexible_server_firewall_rule" "all" {
#   end_ip_address   = "255.255.255.255"
#   name             = "all"
#   server_id        = lookup(jsondecode(azurerm_resource_group_template_deployment.elastic_cluster.output_content).id, "value")
#   start_ip_address = "0.0.0.0"
# }
#
# output "ec_id" {
#   value = jsondecode(azurerm_resource_group_template_deployment.elastic_cluster.output_content).id.value
# }
#
# output "ec_name" {
#   value = jsondecode(azurerm_resource_group_template_deployment.elastic_cluster.output_content).name.value
# }
