# resource "azurerm_resource_group_template_deployment" "flexible_server" {
#   depends_on = [
#     azurerm_role_assignment.cmk_user
#   ]
#   deployment_mode     = "Incremental"
#   name                = format("%s-fs", local.psql_name)
#   template_content    = file("${path.module}/templates/arm_flexible_server.json")
#   resource_group_name = azurerm_resource_group.rg.name
#   parameters_content = templatefile(
#     "${path.module}/templates/parameters_flexible_server.json",
#     {
#       active_directory_auth     = module.global.active_directory_auth,
#       availability_zone         = module.global.availability_zone,
#       backup_retention_days     = module.global.backup_retention_days,
#       cmk_assigned_identity     = azurerm_user_assigned_identity.umi.id,
#       cmk_encryption_type       = module.global.encryption_type
#       cmk_key_uri               = azurerm_key_vault_key.cmk.versionless_id,
#       geo_redundant_backup      = module.global.geo_redundant_backup,
#       ha_mode                   = module.global.ha_mode,
#       identity_type             = module.global.identity_type
#       location                  = azurerm_resource_group.rg.location,
#       name                      = format("%s-fs-0%s", azurerm_resource_group.rg.name, var.index),
#       password_auth             = module.global.password_auth,
#       public_network_access     = module.global.public_network_access,
#       sku_name                  = module.global.ec_sku_name,
#       sku_tier                  = module.global.sku_tier,
#       standby_availability_zone = module.global.standby_availability_zone,
#       storage_autogrow          = module.global.storage_autogrow,
#       storage_size_gb           = module.global.storage_size_gb,
#       tenant_id                 = data.azurerm_client_config.current.tenant_id,
#       version                   = module.global.pg_version
#     }
#   )
# }
#
# resource "azurerm_postgresql_flexible_server_active_directory_administrator" "fs_aad" {
#   object_id           = data.azurerm_client_config.current.object_id
#   principal_name      = data.azuread_service_principal.self.display_name
#   principal_type      = "ServicePrincipal"
#   resource_group_name = azurerm_resource_group.rg.name
#   server_name         = jsondecode(azurerm_resource_group_template_deployment.flexible_server.output_content).name["value"]
#   tenant_id           = data.azurerm_client_config.current.tenant_id
# }
#
# resource "azurerm_postgresql_flexible_server_configuration" "fs_config" {
#   for_each  = module.global.server_configs
#   name      = each.key
#   server_id = jsondecode(azurerm_resource_group_template_deployment.flexible_server.output_content).id["value"]
#   value     = each.value
# }
#
# # resource "azurerm_postgresql_flexible_server_firewall_rule" "fs_all" {
# #   end_ip_address   = "255.255.255.255"
# #   name             = "all"
# #   server_id        = jsondecode(azurerm_resource_group_template_deployment.flexible_server.output_content).id["value"]
# #   start_ip_address = "0.0.0.0"
# # }
#
# output "fs_id" {
#   value = jsondecode(azurerm_resource_group_template_deployment.flexible_server.output_content).id.value
# }
#
# output "fs_name" {
#   value = jsondecode(azurerm_resource_group_template_deployment.flexible_server.output_content).name.value
# }
