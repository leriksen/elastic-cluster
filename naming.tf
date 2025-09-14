locals {
  psql_name = format("%s-psql%s", data.azurerm_resource_group.rg.name, var.index)
  umi_name  = format("%s_umi", local.psql_name)
}