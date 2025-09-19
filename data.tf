data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}
data "azurerm_resource_group" "rg" {
  name = "psql-fs-ec"
}

data "azuread_service_principal" "self" {
  object_id = data.azurerm_client_config.current.object_id
}

data azurerm_log_analytics_workspace law {
  name                = "psql-law01"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data azurerm_user_assigned_identity umi {
  name                = local.umi_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

data azurerm_key_vault kv {
  name                = "psqlkv01"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data azurerm_key_vault_key cmk {
  name         = "cmk"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data azurerm_virtual_network vnet {
  name                = "vnet01"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data azurerm_subnet pe01 {
  name                = "pe01"
  resource_group_name = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}

data azurerm_private_dns_zone psql {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data azurerm_network_interface nic01 {
  name                = "nic01"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data azurerm_postgresql_flexible_server fs {
  depends_on = [
    azurerm_resource_group_template_deployment.flexible_server
  ]
  resource_group_name = data.azurerm_resource_group.rg.name
  name = local.fs_name
}

data azurerm_postgresql_flexible_server fs_replica {
  depends_on = [
    azurerm_resource_group_template_deployment.fs_replica
  ]
  resource_group_name = data.azurerm_resource_group.rg.name
  name = local.fs_replica_name
}

data azurerm_postgresql_flexible_server ec {
  depends_on = [
    azurerm_resource_group_template_deployment.elastic_cluster
  ]
  resource_group_name = data.azurerm_resource_group.rg.name
  name                = local.ec_name
}

data "azurerm_monitor_diagnostic_categories" "fs" {
  resource_id = data.azurerm_postgresql_flexible_server.fs.id
}

data "azurerm_monitor_diagnostic_categories" "fs_replica" {
  resource_id = data.azurerm_postgresql_flexible_server.fs_replica.id
}

data "azurerm_monitor_diagnostic_categories" ec {
  resource_id = data.azurerm_postgresql_flexible_server.ec.id
}

data azurerm_data_protection_backup_vault bv {
  name                = "psql-fs-ec-vault"
  resource_group_name = data.azurerm_resource_group.rg.name
}
