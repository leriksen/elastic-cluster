locals {
  psql_name = format("%s-psql%s", azurerm_resource_group.rg.name, var.index)
  umi_name  = format("%s-umi", azurerm_resource_group.rg.name)
  fs_name = format("%s-fs-0%s", azurerm_resource_group.rg.name, var.index)
  ec_name = format("%s-ec-0%s", azurerm_resource_group.rg.name, var.index)
  fs_replica_name = format("%s-replica", local.fs_name)
  ec_replica_name = format("%s-replica", local.ec_name)
}