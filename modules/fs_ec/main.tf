resource "azurerm_resource_group_template_deployment" "postgres" {
  deployment_mode     = "Incremental"
  name                = local.psql_name
  template_content    = file("${path.module}/templates/arm_postgres.json")
  resource_group_name = var.rg_name
  parameters_content = templatefile(
    "${path.module}/templates/parameters_postgres.json",
    {
      active_directory_auth     = var.active_directory_auth
      availability_zone         = var.availability_zone
      backup_retention_days     = var.backup_retention_days
      cluster_size              = var.cluster_size
      cmk_assigned_identity     = var.umi_id
      cmk_encryption_type       = var.encryption_type
      cmk_key_uri               = var.cmk_versionless_id
      create_mode               = "Default"
      geo_redundant_backup      = var.geo_redundant_backup
      ha_mode                   = var.ha_mode
      identity_type             = var.identity_type
      location                  = var.location
      name                      = local.ec_name
      password_auth             = var.password_auth
      public_network_access     = var.public_network_access
      replication_role          = "Primary"
      sku_name                  = var.ec_sku_name
      sku_tier                  = var.sku_tier
      source_server_id          = var.source_server_id
      standby_availability_zone = var.standby_availability_zone
      storage_autogrow          = var.storage_autogrow
      storage_size_gb           = var.storage_size_gb
      tenant_id                 = var.tenant_id
      version                   = var.pg_version
    }
  )
}

resource "azurerm_resource_group_template_deployment" "replica" {
  for_each = var.replica_count == 0 ? [] : [0..var.replica_count]
  deployment_mode     = "Incremental"
  name                = format("%s-%s", local.ec_replica_name, each.value)
  template_content    = file("${path.module}/templates/arm_postgres.json")
  resource_group_name = var.rg_name
  parameters_content = templatefile(
    "${path.module}/templates/arm_postgres.json",
    {
      active_directory_auth     = var.active_directory_auth
      availability_zone         = var.availability_zone
      backup_retention_days     = var.backup_retention_days
      cluster_size              = var.cluster_size
      cmk_assigned_identity     = var.umi_id
      cmk_encryption_type       = var.encryption_type
      cmk_key_uri               = var.cmk_versionless_id
      create_mode               = "Replica"
      geo_redundant_backup      = var.geo_redundant_backup
      ha_mode                   = var.ha_mode
      identity_type             = var.identity_type
      location                  = var.location
      name                      = local.psql_name
      password_auth             = var.password_auth
      public_network_access     = var.public_network_access
      replication_role          = "Async"
      sku_name                  = var.ec_sku_name
      sku_tier                  = var.sku_tier
      source_server_id          = data.azurerm_postgresql_flexible_server.ec.id
      standby_availability_zone = var.standby_availability_zone
      storage_autogrow          = var.storage_autogrow
      storage_size_gb           = var.storage_size_gb
      tenant_id                 = var.tenant_id
      version                   = var.pg_version
    }
  )
}

resource "azurerm_postgresql_flexible_server_active_directory_administrator" "aad" {
  depends_on = [
    azurerm_resource_group_template_deployment.postgres
  ]
  object_id           = data.azurerm_client_config.current.object_id
  principal_name      = data.azuread_service_principal.self.display_name
  principal_type      = "ServicePrincipal"
  resource_group_name = var.rg_name
  server_name         = local.psql_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
}

resource "azurerm_postgresql_flexible_server_active_directory_administrator" "replica_aad" {
  count = var.replica_count
  depends_on = [
    azurerm_resource_group_template_deployment.postgres
  ]
  object_id           = data.azurerm_client_config.current.object_id
  principal_name      = data.azuread_service_principal.self.display_name
  principal_type      = "ServicePrincipal"
  resource_group_name = var.rg_name
  server_name         = local.psql_replica_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
}

resource "azurerm_postgresql_flexible_server_configuration" "replica" {
  for_each  = var.server_configs
  name      = each.key
  server_id = data.azurerm_postgresql_flexible_server.replica.id
  value     = each.value
}


resource "azurerm_monitor_diagnostic_setting" "diag" {
  name                       = "ds_ec"
  target_resource_id         = data.azurerm_postgresql_flexible_server.postgres.id
  log_analytics_workspace_id = var.law_id

  dynamic "enabled_log" {
    for_each = data.azurerm_monitor_diagnostic_categories.psql.log_category_groups
    content {
      category_group = enabled_log.value
    }
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_diagnostic_setting" "replica" {
  name                       = "ds_ec"
  target_resource_id         = data.azurerm_postgresql_flexible_server.replica.id
  log_analytics_workspace_id = var.law_id

  dynamic "enabled_log" {
    for_each = data.azurerm_monitor_diagnostic_categories.replica.log_category_groups
    content {
      category_group = enabled_log.value
    }
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
