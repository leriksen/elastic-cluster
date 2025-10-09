resource azurerm_resource_group_template_deployment elastic_cluster {
  deployment_mode     = "Incremental"
  name                = local.ec_name
  template_content    = file("${path.module}/templates/arm_postgres.json")
  resource_group_name = data.azurerm_resource_group.rg.name
  parameters_content = templatefile(
    "${path.module}/templates/parameters_postgres.json",
    {
      active_directory_auth     = module.global.active_directory_auth
      availability_zone         = module.global.availability_zone
      backup_retention_days     = module.global.backup_retention_days
      cluster_size              = module.global.cluster_size
      cmk_assigned_identity     = data.azurerm_user_assigned_identity.umi.id
      cmk_encryption_type       = module.global.encryption_type
      cmk_key_uri               = data.azurerm_key_vault_key.cmk.versionless_id
      create_mode               = "Default"
      day_of_week               = module.global.day_of_week
      geo_redundant_backup      = module.global.geo_redundant_backup
      ha_mode                   = module.global.ha_mode
      identity_type             = module.global.identity_type
      location                  = data.azurerm_resource_group.rg.location
      name                      = local.ec_name
      password_auth             = module.global.password_auth
      public_network_access     = module.global.public_network_access
      replication_role          = "Primary"
      sku_name                  = module.global.ec_sku_name
      sku_tier                  = module.global.sku_tier
      source_server_id          = ""
      standby_availability_zone = module.global.standby_availability_zone
      start_hour                = module.global.start_hour
      start_minute              = module.global.start_minute
      storage_autogrow          = module.global.storage_autogrow
      storage_iops              = module.global.storage_iops
      storage_size_gb           = floor(module.global.storage_size_mb / 1000)
      storage_throughput        = module.global.storage_throughput
      storage_type              = module.global.storage_type
      tenant_id                 = data.azurerm_client_config.current.tenant_id
      version                   = module.global.pg_version
    }
  )
}

resource azurerm_postgresql_flexible_server_active_directory_administrator ec_aad {
  depends_on = [
    data.azurerm_postgresql_flexible_server.ec
  ]

  object_id           = data.azurerm_client_config.current.object_id
  principal_name      = data.azuread_service_principal.self.display_name
  principal_type      = "ServicePrincipal"
  resource_group_name = data.azurerm_resource_group.rg.name
  server_name         = local.ec_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
}

# resource azurerm_postgresql_flexible_server_active_directory_administrator vm_aad {
#   depends_on = [
#     azurerm_resource_group_template_deployment.elastic_cluster
#   ]
#
#   object_id           = azurerm_linux_virtual_machine.vm02.identity[0].principal_id
#   principal_name      = azurerm_linux_virtual_machine.vm02.name
#   principal_type      = "ServicePrincipal"
#   resource_group_name = data.azurerm_resource_group.rg.name
#   server_name         = local.ec_name
#   tenant_id           = data.azurerm_client_config.current.tenant_id
# }
#
# resource azurerm_postgresql_flexible_server_configuration ec_config {
#   for_each  = module.global.server_configs
#   name      = each.key
#   server_id = data.azurerm_postgresql_flexible_server.ec.id
#   value     = each.value
# }
#
# resource azurerm_monitor_diagnostic_setting ec {
#   name                       = "ds_ec"
#   target_resource_id         = data.azurerm_postgresql_flexible_server.ec.id
#   log_analytics_workspace_id = data.azurerm_log_analytics_workspace.law.id
#
#   dynamic "enabled_log" {
#     for_each = data.azurerm_monitor_diagnostic_categories.ec.log_category_groups
#     content {
#       category_group = enabled_log.value
#     }
#   }
#
#   enabled_metric {
#     category = "AllMetrics"
#   }
# }
#
# resource azurerm_role_assignment backup_role_ec {
#   principal_id         = data.azurerm_data_protection_backup_vault.bv.identity[0].principal_id
#   role_definition_name = "PostgreSQL Flexible Server Long Term Retention Backup Role"
#   scope                = data.azurerm_postgresql_flexible_server.ec.id
#
# }
#
# resource azurerm_data_protection_backup_policy_postgresql_flexible_server postgresql_backup_policy {
#   name     = "postgresql-backup-policy-ec"
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
#
# resource azurerm_data_protection_backup_instance_postgresql_flexible_server postgresql_backup_instance_ec {
#   name             = format("backup-%s", data.azurerm_postgresql_flexible_server.ec.name)
#   location         = data.azurerm_resource_group.rg.location
#   vault_id         = data.azurerm_data_protection_backup_vault.bv.id
#   server_id        = data.azurerm_postgresql_flexible_server.ec.id
#   backup_policy_id = azurerm_data_protection_backup_policy_postgresql_flexible_server.postgresql_backup_policy.id
#
#   depends_on = [
#     azurerm_role_assignment.backup_role_ec
#   ]
# }
