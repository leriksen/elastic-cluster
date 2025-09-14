# resource "azurerm_resource_group_template_deployment" "flexible_server" {
#   depends_on = [
#     azurerm_role_assignment.secret_reader
#   ]
#   deployment_mode     = "Incremental"
#   name                = format("%s-fs-%s", local.psql_name, formatdate("YYYYMMDDhhmmss", timestamp()))
#   template_content    = file("${path.module}/templates/arm_flexible_server.json")
#   resource_group_name = data.azurerm_resource_group.rg.name
#   parameters_content  = templatefile(
#     "${path.module}/templates/parameters_flexible_server.json",
#     {
#       active_directory_auth        = module.global.active_directory_auth,
#       availability_zone            = module.global.availability_zone,
#       backup_retention_days        = module.global.backup_retention_days,
#       cmk_assigned_identity        = azurerm_user_assigned_identity.umi.id,
#       cmk_key_uri                  = azurerm_key_vault_key.cmk.resource_versionless_id,
#       geo_redundant_backup         = module.global.geo_redundant_backup,
#       ha_mode                      = module.global.ha_mode,
#       location                     = data.azurerm_resource_group.rg.location,
#       name                         = format("%s-pgfsec-0%s", data.azurerm_resource_group.rg.name, var.index),
#       password_auth                = module.global.password_auth,
#       sku_name                     = module.global.ec_sku_name,
#       sku_tier                     = module.global.sku_tier,
#       standby_availability_zone    = module.global.standby_availability_zone,
#       storage_autogrow             = module.global.storage_autogrow,
#       storage_size_gb              = module.global.storage_size_gb,
#       tenant_id                    = data.azurerm_client_config.current.tenant_id,
#       version                      = module.global.pg_version
#     }
#   )
# }

resource "azurerm_postgresql_flexible_server" "flexible_server" {
  depends_on = [
    azurerm_role_assignment.secret_reader
  ]

  auto_grow_enabled            = module.global.storage_autogrow_bool
  backup_retention_days        = module.global.backup_retention_days
  create_mode                  = "Default"
  geo_redundant_backup_enabled = module.global.geo_redundant_backup_bool
  location                     = data.azurerm_resource_group.rg.location
  name                         = format("%s-fs-%s", local.psql_name, formatdate("YYYYMMDDhhmmss", timestamp()))
  resource_group_name          = data.azurerm_resource_group.rg.name
  sku_name                     = module.global.sku_name
  storage_mb                   = module.global.storage_size_mb
  version                      = module.global.pg_version
  zone                         = module.global.availability_zone

  authentication {
    active_directory_auth_enabled = module.global.active_directory_auth_bool
    password_auth_enabled         = module.global.password_auth_bool
    tenant_id                     = data.azurerm_client_config.current.tenant_id
  }

  customer_managed_key {
    key_vault_key_id                  = azurerm_key_vault_key.cmk.versionless_id
    primary_user_assigned_identity_id = azurerm_user_assigned_identity.umi.id
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.umi.id
    ]
  }
  high_availability {
    mode                      = module.global.ha_mode
    standby_availability_zone = module.global.standby_availability_zone
  }
}

#
# resource "azurerm_monitor_diagnostic_setting" "logging" {
#   name               = "logging"
#   target_resource_id = jsondecode(azurerm_resource_group_template_deployment.flexible_server.output_content).id.value
#   storage_account_id = azurerm_storage_account.sa.id
#   enabled_log {}
#   enabled_metric {
#    category = "AllMetrics"
#  }
# }

resource "azurerm_postgresql_flexible_server_active_directory_administrator" "aad" {
  object_id           = data.azurerm_client_config.current.object_id
  principal_name      = data.azuread_service_principal.self.display_name
  principal_type      = "ServicePrincipal"
  resource_group_name = data.azurerm_resource_group.rg.name
  # server_name         = jsondecode(azurerm_resource_group_template_deployment.flexible_server.output_content).name["value"]
  server_name         = azurerm_postgresql_flexible_server.flexible_server.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
}

resource "azurerm_postgresql_flexible_server_configuration" "config" {
  for_each  = module.global.server_configs
  name      = each.key
  # server_id = jsondecode(azurerm_resource_group_template_deployment.flexible_server.output_content).id["value"]
  server_id = azurerm_postgresql_flexible_server.flexible_server.id
  value     = each.value
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "all" {
  end_ip_address   = "255.255.255.255"
  name             = "all"
#   server_id        = jsondecode(azurerm_resource_group_template_deployment.flexible_server.output_content).id["value"]
  server_id        = azurerm_postgresql_flexible_server.flexible_server.id
  start_ip_address = "0.0.0.0"
}

output "fs_id" {
#   value = jsondecode(azurerm_resource_group_template_deployment.flexible_server.output_content).id.value
  value = azurerm_postgresql_flexible_server.flexible_server.id
}

output "fs_name" {
#   value = jsondecode(azurerm_resource_group_template_deployment.flexible_server.output_content).name.value
  value = azurerm_postgresql_flexible_server.flexible_server.name
}
