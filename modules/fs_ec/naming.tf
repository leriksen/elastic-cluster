locals {
  psql_name = format("%s-psql%s", var.rg_name, var.index)
  umi_name  = format("%s_umi", local.psql_name)
  psql_name = format("%s-fs-0%s", var.rg_name, var.index)
  psql_replica_name = format("%s-replica", local.psql_name)
}