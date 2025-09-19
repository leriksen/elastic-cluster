locals {
  psql_name = format("%s-psql%s", data.azurerm_resource_group.rg.name, var.index)
  umi_name  = format("%s-umi", data.azurerm_resource_group.rg.name)
  ec_name = format("%s-ec-0%s", data.azurerm_resource_group.rg.name, var.index)
  ec_replica_name = format("%s-replica", local.ec_name)
}