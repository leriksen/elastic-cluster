resource "azurerm_resource_group_template_deployment" "flexible_server" {
  depends_on = [
    azurerm_role_assignment.cmk_user
  ]
  deployment_mode     = "Incremental"
  name                = local.fs_name
  template_content    = file("${path.module}/templates/arm_flexible_server.json")
  resource_group_name = azurerm_resource_group.rg.name
  parameters_content = templatefile(
    "${path.module}/templates/parameters_flexible_server.json",
    {
      active_directory_auth     = module.global.active_directory_auth
      availability_zone         = module.global.availability_zone
      backup_retention_days     = module.global.backup_retention_days
      cmk_assigned_identity     = azurerm_user_assigned_identity.umi.id
      cmk_encryption_type       = module.global.encryption_type
      cmk_key_uri               = azurerm_key_vault_key.cmk.versionless_id
      create_mode               = "Default"
      geo_redundant_backup      = module.global.geo_redundant_backup
      ha_mode                   = module.global.ha_mode
      identity_type             = module.global.identity_type
      location                  = azurerm_resource_group.rg.location
      name                      = format("%s-fs-0%s", azurerm_resource_group.rg.name, var.index)
      password_auth             = module.global.password_auth
      public_network_access     = module.global.public_network_access
      replication_role          = "Primary"
      sku_name                  = module.global.ec_sku_name
      sku_tier                  = module.global.sku_tier
      source_server_id          = ""
      standby_availability_zone = module.global.standby_availability_zone
      storage_autogrow          = module.global.storage_autogrow
      storage_size_gb           = module.global.storage_size_gb
      tenant_id                 = data.azurerm_client_config.current.tenant_id
      version                   = module.global.pg_version
    }
  )
}

# resource "azurerm_resource_group_template_deployment" "fs_replica" {
#   deployment_mode     = "Incremental"
#   name                = format("%s-fs-replica", local.fs_name)
#   template_content    = file("${path.module}/templates/arm_flexible_server.json")
#   resource_group_name = azurerm_resource_group.rg.name
#   parameters_content = templatefile(
#     "${path.module}/templates/parameters_flexible_server.json",
#     {
#       active_directory_auth     = module.global.active_directory_auth
#       availability_zone         = module.global.availability_zone
#       backup_retention_days     = module.global.backup_retention_days
#       cmk_assigned_identity     = azurerm_user_assigned_identity.umi.id
#       cmk_encryption_type       = module.global.encryption_type
#       cmk_key_uri               = azurerm_key_vault_key.cmk.versionless_id
#       create_mode               = "Replica"
#       geo_redundant_backup      = module.global.geo_redundant_backup
#       ha_mode                   = module.global.ha_mode
#       identity_type             = module.global.identity_type
#       location                  = azurerm_resource_group.rg.location
#       name                      = local.fs_name
#       password_auth             = module.global.password_auth
#       public_network_access     = module.global.public_network_access
#       replication_role          = "Async"
#       source_server_id          = jsondecode(azurerm_resource_group_template_deployment.flexible_server.output_content).id.value
#       sku_name                  = module.global.ec_sku_name
#       sku_tier                  = module.global.sku_tier
#       standby_availability_zone = module.global.standby_availability_zone
#       storage_autogrow          = module.global.storage_autogrow
#       storage_size_gb           = module.global.storage_size_gb
#       tenant_id                 = data.azurerm_client_config.current.tenant_id
#       version                   = module.global.pg_version
#     }
#   )
# }

resource "azurerm_postgresql_flexible_server_active_directory_administrator" "fs_aad" {
  depends_on = [
    azurerm_resource_group_template_deployment.elastic_cluster
  ]

  object_id           = data.azurerm_client_config.current.object_id
  principal_name      = data.azuread_service_principal.self.display_name
  principal_type      = "ServicePrincipal"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = local.fs_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
}

resource "azurerm_postgresql_flexible_server_configuration" "fs_config" {
  timeouts {
    delete = "5m"
  }
  for_each  = module.global.server_configs
  name      = each.key
  server_id = data.azurerm_postgresql_flexible_server.fs.id
  value     = each.value
}

resource "azurerm_monitor_diagnostic_setting" "fs" {
  name                       = "ds_fs"
  target_resource_id         = data.azurerm_postgresql_flexible_server.fs.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  dynamic "enabled_log" {
    for_each = data.azurerm_monitor_diagnostic_categories.fs.log_category_groups
    content {
      category_group = enabled_log.value
    }
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
