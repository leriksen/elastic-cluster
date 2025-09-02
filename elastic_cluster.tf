resource "azurerm_postgresql_flexible_server" "pgfs" {
  location            = data.azurerm_resource_group.rg.location
  name                = format("%s-pgfs-0%s", data.azurerm_resource_group.rg.name, module.global.index)
  resource_group_name = data.azurerm_resource_group.rg.name
  sku_name            = module.global.sku_name
  version             = "16"
  zone                = 1
  authentication {
    active_directory_auth_enabled = true
    password_auth_enabled         = false
    tenant_id                     = data.azurerm_client_config.current.tenant_id
  }
}

resource "azurerm_postgresql_flexible_server_active_directory_administrator" "aad_admin" {
  resource_group_name = data.azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_flexible_server.pgfs.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
  principal_name      = data.azuread_user.self.display_name
  principal_type      = "User"
}

resource "azurerm_resource_group_template_deployment" "elastic_cluster" {
  deployment_mode     = "Incremental"
  name                = "elastic_cluster"
  template_content    = file("${path.module}/templates/arm_elastic_cluster.json")
  resource_group_name = data.azurerm_resource_group.rg.name
  parameters_content  = jsonencode({
    name = {
      value = azurerm_postgresql_flexible_server.pgfs.name
    }
    location = {
      value = data.azurerm_resource_group.rg.location
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
  })
}
