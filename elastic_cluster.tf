# resource "azurerm_postgresql_flexible_server" "pgfs" {
#   location            = data.azurerm_resource_group.rg.location
#   name                = format("%s-pgfs-0%s", data.azurerm_resource_group.rg.name, module.global.index)
#   resource_group_name = data.azurerm_resource_group.rg.name
#   sku_name            = module.global.sku_name
#   version             = "16"
#   zone                = 1
#   authentication {
#     active_directory_auth_enabled = true
#     password_auth_enabled         = false
#     tenant_id                     = data.azurerm_client_config.current.tenant_id
#   }
# }
#

resource "azurerm_resource_group_template_deployment" "elastic_cluster" {
  deployment_mode     = "Incremental"
  name                = "elastic_cluster"
  template_content    = file("${path.module}/templates/arm_elastic_cluster.json")
  resource_group_name = data.azurerm_resource_group.rg.name
  parameters_content  = jsonencode({
    name = {
      value = format("%s-pgfsec-0%s", data.azurerm_resource_group.rg.name, var.index)
    }
    version = {
      value = module.global.pg_version
    }
    location = {
      value = data.azurerm_resource_group.rg.location
    }
    availability_zone = {
      value = module.global.availability_zone
    }
    sku_name = {
      value = module.global.ec_sku_name
    }
    sku_tier = {
      value = module.global.sku_tier
    }
    cluster_size = {
      value = module.global.cluster_size
    }
    administrator_login = {
      value = module.global.administrator_login
    }
    administrator_login_password = {
      value = module.global.administrator_login_password
    }
    password_auth = {
      value = module.global.password_auth
    }
    storage_size_gb = {
      value = module.global.storage_size_gb
    }
    storage_autogrow = {
      value = module.global.storage_autogrow
    }
    backup_retention_days = {
      value = module.global.backup_retention_days
    }
    geo_redundant_backup = {
      value = module.global.geo_redundant_backup
    }
    ha_mode = {
      value = module.global.ha_mode
    }
    standby_availability_zone = {
      value = module.global.standby_availability_zone
    }
    active_directory_auth = {
      value = module.global.active_directory_auth
    }
    tenant_id = {
      value = data.azurerm_client_config.current.tenant_id
    }
    principal_name = {
      value = data.azuread_user.self.display_name
    }
    principal_type = {
      value = "User"
    }
    principal_id = {
      value = data.azurerm_client_config.current.object_id
    }
  })
}
#
# resource "azurerm_postgresql_flexible_server_active_directory_administrator" "aad_admin" {
#   resource_group_name = data.azurerm_resource_group.rg.name
#   server_name         = azurerm_postgresql_flexible_server.pgfs.name
#   tenant_id           = data.azurerm_client_config.current.tenant_id
#   object_id           = data.azurerm_client_config.current.object_id
#   principal_name      = data.azuread_user.self.display_name
#   principal_type      = "User"
# }
