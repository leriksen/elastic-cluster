locals {
  umi_name          = format("%s-umi", data.azurerm_resource_group.rg.name)
  psql_name         = format("%s-ec-psql0%s", data.azurerm_resource_group.rg.name, var.index)
  psql_replica_name = format("%s-replica", local.psql_name)
}