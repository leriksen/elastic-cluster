# resource "azurerm_private_endpoint" "psql-pe01-ec" {
#   location            = data.azurerm_resource_group.rg.location
#   name                = "psql-pe01-ec"
#   resource_group_name = data.azurerm_resource_group.rg.name
#   subnet_id           = data.azurerm_subnet.pe01.id
#
#   private_service_connection {
#     name                           = "psql-pe01-ec-psc"
#     private_connection_resource_id = data.azurerm_postgresql_flexible_server.ec.id
#     subresource_names              = ["postgresqlServer"]
#     is_manual_connection           = false
#   }
#
#   private_dns_zone_group {
#     name                 = "psql-pe01-ec-dns-zone-group"
#     private_dns_zone_ids = [data.azurerm_private_dns_zone.psql.id]
#   }
# }
#
# resource "azurerm_public_ip" "ip02" {
#   location            = data.azurerm_resource_group.rg.location
#   name                = "ip02"
#   resource_group_name = data.azurerm_resource_group.rg.name
#   allocation_method   = "Static"
# }
#
# resource "azurerm_network_interface" "nic01" {
#   name                = "vm02-nic01"
#   location            = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name
#
#   ip_configuration {
#     name                          = "public"
#     private_ip_address_allocation = "Dynamic"
#     subnet_id                     = data.azurerm_subnet.pe01.id
#     public_ip_address_id          = azurerm_public_ip.ip02.id
#   }
# }
