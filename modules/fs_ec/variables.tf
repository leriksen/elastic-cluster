
variable active_directory_auth {
  type = string
}
variable availability_zone {
  type = string
}
variable backup_retention_days {
  type = string
}
variable cluster_size {
  type = string
}
variable cmk_versionless_id {
  type = string
}
variable encryption_type {
  type = string
}
variable geo_redundant_backup {
  type = string
}
variable ha_mode {
  type = string
}
variable identity_type {
  type = string
}
variable law_id {
  type = string
}
variable location {
  type = string
}
variable password_auth {
  type = string
}
variable pg_version {
  type = string
}
variable public_network_access {
  type = string
}
variable ec_sku_name {
  type = string
}
variable replica_count {
  type = number
  default = 0
}
variable rg_name {
  type = string
}
variable server_configs {
  type = map(any)
}
variable sku_tier {
  type = string
}
variable standby_availability_zone {
  type = string
}
variable storage_autogrow {
  type = string
}
variable storage_size_gb {
  type = string
}
variable tenant_id {
  type = string
}
variable umi_id {
  type = string
}