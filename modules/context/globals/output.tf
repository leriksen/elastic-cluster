output "active_directory_auth" {
  value = "Enabled"
}

output "active_directory_auth_bool" {
  value = true
}

output "administrator_login" {
  value = "psqladmin"
}

output "availability_zone" {
  value = "1"
}

output "backup_retention_days" {
  value = "7"
}

output "cluster_size" {
  value = "2"
}

output "ec_sku_name" {
  value = "Standard_D4ads_v5"
}

output "encryption_type" {
  value = "AzureKeyVault"
}

output "geo_redundant_backup" {
  value = "Disabled"
}

output "geo_redundant_backup_bool" {
  value = false
}

output "ha_mode" {
  value = "ZoneRedundant"
}

output "identity_type" {
  value = "UserAssigned"
}

output "index" {
  value = "1"
}

output "location" {
  value = "AustraliaEast"
}

output "password_auth" {
  value = "Disabled"
}

output "password_auth_bool" {
  value = false
}

output "pg_version" {
  value = "16"
}

output "public_network_access" {
  value = "Disabled"
}

output "server_configs" {
  value = {
    "pg_qs.query_capture_mode"              = "ALL"
    "pgms_wait_sampling.query_capture_mode" = "ALL"
    "track_io_timing"                       = "ON"
    "pgbouncer.enabled"                     = "true"
    "azure.extensions"                      = "VECTOR"
  }
}

output "sku_name" {
  value = "GP_Standard_D4ads_v5"
}

output "sku_tier" {
  value = "GeneralPurpose"
}

output "standby_availability_zone" {
  value = "2"
}

output "storage_autogrow" {
  value = "Disabled"
}

output "storage_autogrow_bool" {
  value = false
}

output "storage_iops" {
  value = ""
}

output "storage_throughput" {
  value = ""
}

output "storage_type" {
  value = "Premium_LRS"
}

output "storage_size_gb" {
  value = "128"
}

output "storage_size_mb" {
  value = "32768"
}

output "timezone" {
  value = "AUS Eastern Standard Time"
}
