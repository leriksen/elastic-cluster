resource "azurerm_resource_group_template_deployment" "flexible_server" {
  deployment_mode     = "Incremental"
  name                = local.fs_name
  template_content    = file("${path.module}/templates/arm_postgres.json")
  resource_group_name = data.azurerm_resource_group.rg.name
  parameters_content = templatefile(
    "${path.module}/templates/parameters_postgres.json",
    {
      active_directory_auth     = module.global.active_directory_auth
      availability_zone         = module.global.availability_zone
      backup_retention_days     = module.global.backup_retention_days
      cluster_size              = ""
      cmk_assigned_identity     = data.azurerm_user_assigned_identity.umi.id
      cmk_encryption_type       = module.global.encryption_type
      cmk_key_uri               = data.azurerm_key_vault_key.cmk.versionless_id
      create_mode               = "Default"
      geo_redundant_backup      = module.global.geo_redundant_backup
      ha_mode                   = module.global.ha_mode
      identity_type             = module.global.identity_type
      location                  = data.azurerm_resource_group.rg.location
      name                      = local.fs_name
      password_auth             = module.global.password_auth
      public_network_access     = module.global.public_network_access
      replication_role          = "Primary"
      sku_name                  = module.global.ec_sku_name
      sku_tier                  = module.global.sku_tier
      source_server_id          = ""
      standby_availability_zone = module.global.standby_availability_zone
      storage_autogrow          = module.global.storage_autogrow
      storage_iops              = module.global.storage_iops
      storage_size_gb           = module.global.storage_size_gb
      storage_throughput        = module.global.storage_throughput
      storage_type              = module.global.storage_type
      tenant_id                 = data.azurerm_client_config.current.tenant_id
      version                   = module.global.pg_version
    }
  )
}

resource "azurerm_resource_group_template_deployment" "fs_replica" {
  deployment_mode     = "Incremental"
  name                = local.fs_replica_name
  template_content    = file("${path.module}/templates/arm_postgres.json")
  resource_group_name = data.azurerm_resource_group.rg.name
  parameters_content = templatefile(
    "${path.module}/templates/parameters_postgres.json",
    {
      active_directory_auth     = module.global.active_directory_auth
      availability_zone         = module.global.availability_zone
      backup_retention_days     = module.global.backup_retention_days
      cluster_size              = ""
      cmk_assigned_identity     = data.azurerm_user_assigned_identity.umi.id
      cmk_encryption_type       = module.global.encryption_type
      cmk_key_uri               = data.azurerm_key_vault_key.cmk.versionless_id
      create_mode               = "Replica"
      geo_redundant_backup      = module.global.geo_redundant_backup
      ha_mode                   = module.global.ha_mode
      identity_type             = module.global.identity_type
      location                  = data.azurerm_resource_group.rg.location
      name                      = local.fs_replica_name
      password_auth             = module.global.password_auth
      public_network_access     = module.global.public_network_access
      replication_role          = "Async"
      sku_name                  = module.global.ec_sku_name
      sku_tier                  = module.global.sku_tier
      source_server_id          = data.azurerm_postgresql_flexible_server.fs.id
      standby_availability_zone = module.global.standby_availability_zone
      storage_autogrow          = module.global.storage_autogrow
      storage_iops              = module.global.storage_iops
      storage_size_gb           = module.global.storage_size_gb
      storage_throughput        = module.global.storage_throughput
      storage_type              = module.global.storage_type
      tenant_id                 = data.azurerm_client_config.current.tenant_id
      version                   = module.global.pg_version
    }
  )
}

resource "azurerm_postgresql_flexible_server_active_directory_administrator" "fs_aad" {
  depends_on = [
    azurerm_resource_group_template_deployment.flexible_server
  ]

  object_id           = data.azurerm_client_config.current.object_id
  principal_name      = data.azuread_service_principal.self.display_name
  principal_type      = "ServicePrincipal"
  resource_group_name = data.azurerm_resource_group.rg.name
  server_name         = local.fs_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
}

resource "azurerm_postgresql_flexible_server_active_directory_administrator" "fs_replica_aad" {
  depends_on = [
    azurerm_resource_group_template_deployment.fs_replica
  ]

  object_id           = data.azurerm_client_config.current.object_id
  principal_name      = data.azuread_service_principal.self.display_name
  principal_type      = "ServicePrincipal"
  resource_group_name = data.azurerm_resource_group.rg.name
  server_name         = local.fs_replica_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
}

resource "azurerm_postgresql_flexible_server_configuration" "fs_config" {
  for_each  = module.global.server_configs
  name      = each.key
  server_id = data.azurerm_postgresql_flexible_server.fs.id
  value     = each.value
}

resource "azurerm_postgresql_flexible_server_configuration" "fs_replica_config" {
  for_each  = module.global.server_configs
  name      = each.key
  server_id = data.azurerm_postgresql_flexible_server.fs_replica.id
  value     = each.value
}

resource "azurerm_monitor_diagnostic_setting" "fs" {
  name                       = "ds_fs"
  target_resource_id         = data.azurerm_postgresql_flexible_server.fs.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.law.id

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

resource "azurerm_monitor_diagnostic_setting" "fs_replica" {
  name                       = "ds_fs"
  target_resource_id         = data.azurerm_postgresql_flexible_server.fs_replica.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.law.id

  dynamic "enabled_log" {
    for_each = data.azurerm_monitor_diagnostic_categories.fs_replica.log_category_groups
    content {
      category_group = enabled_log.value
    }
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

resource azurerm_role_assignment backup_role_fs {
  principal_id         = data.azurerm_data_protection_backup_vault.bv.identity[0].principal_id
  role_definition_name = "PostgreSQL Flexible Server Long Term Retention Backup Role"
  scope                = data.azurerm_postgresql_flexible_server.fs.id
}

# resource azurerm_role_assignment reader_role {
#   principal_id         = data.azurerm_data_protection_backup_vault.bv.identity[0].principal_id
#   role_definition_name = "Reader"
#   scope                = data.azurerm_resource_group.rg.id
#
#   depends_on = [
#     azurerm_role_assignment.backup_role
#   ]
# }
#
# resource azurerm_data_protection_backup_policy_postgresql_flexible_server postgresql_backup_policy {
#   name     = "postgresql-backup-policy"
#   vault_id = data.azurerm_data_protection_backup_vault.bv.id
#   backup_repeating_time_intervals = [
#     "R/2025-09-19T05:30:00+10:00/P1W"
#   ]
#   time_zone = module.global.timezone
#
#   default_retention_rule {
#     life_cycle {
#       duration        = "P4M"
#       data_store_type = "VaultStore"
#     }
#   }
# }

resource azurerm_data_protection_backup_instance_postgresql_flexible_server postgresql_backup_instance_fs {
  name             = format("backup-%s", data.azurerm_postgresql_flexible_server.fs.name)
  location         = data.azurerm_resource_group.rg.location
  vault_id         = data.azurerm_data_protection_backup_vault.bv.id
  server_id        = data.azurerm_postgresql_flexible_server.fs.id
  backup_policy_id = azurerm_data_protection_backup_policy_postgresql_flexible_server.postgresql_backup_policy.id

  depends_on = [
    azurerm_role_assignment.reader_role
  ]
}