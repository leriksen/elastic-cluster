# resource "azurerm_private_endpoint" "psql-pe01-fs" {
#   location            = azurerm_resource_group.rg.location
#   name                = "psql-pe01-fs"
#   resource_group_name = azurerm_resource_group.rg.name
#   subnet_id           = azurerm_subnet.pe01.id
#
#   private_service_connection {
#     name                           = "psql-pe01-fs-psc"
#     private_connection_resource_id = data.azurerm_postgresql_flexible_server.fs.id
#     subresource_names              = ["postgresqlServer"]
#     is_manual_connection           = false
#   }
#
#   private_dns_zone_group {
#     name                 = "psql-pe01-fs-dns-zone-group"
#     private_dns_zone_ids = [azurerm_private_dns_zone.psql.id]
#   }
# }
#
# resource "azurerm_private_endpoint" "psql-pe01-fs-replica" {
#   location            = azurerm_resource_group.rg.location
#   name                = "psql-pe01-fs-replica"
#   resource_group_name = azurerm_resource_group.rg.name
#   subnet_id           = azurerm_subnet.pe01.id
#
#   private_service_connection {
#     name                           = "psql-pe01-fs-replica-psc"
#     private_connection_resource_id = data.azurerm_postgresql_flexible_server.fs_replica.id
#     subresource_names              = ["postgresqlServer"]
#     is_manual_connection           = false
#   }
#
#   private_dns_zone_group {
#     name                 = "psql-pe01-fs-dns-zone-group"
#     private_dns_zone_ids = [azurerm_private_dns_zone.psql.id]
#   }
# }

resource "azurerm_private_endpoint" "psql-pe01-ec" {
  location            = data.azurerm_resource_group.rg.location
  name                = "psql-pe010-ec"
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.pe01.id

  private_service_connection {
    name                           = "psql-pe01-ec-psc"
    private_connection_resource_id = data.azurerm_postgresql_flexible_server.ec.id
    subresource_names              = ["postgresqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "psql-pe01-ec-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.psql.id]
  }
}

resource "azurerm_private_endpoint" "vm-pe01" {
  location            = data.azurerm_resource_group.rg.location
  name                = "vm-pe010"
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.pe01.id

  private_service_connection {
    name                           = "vm-pe01-psc"
    private_connection_resource_id = data.azurerm_postgresql_flexible_server.ec.id
    subresource_names              = ["postgresqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "psql-pe01-ec-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.psql.id]
  }
}
