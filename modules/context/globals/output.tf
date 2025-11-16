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
  value = 2
}

output "day_of_week" {
  value = "1"
}

output "ec_sku_name" {
  value = "Standard_D2ads_v5"
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
  value = "Enabled"
}

output "pg_version" {
  value = "17"
}

output "public_network_access" {
  value = "Enabled"
}

output "server_configs" {
  value = {
    # note the casing is chosen to reduce TF flip/flops
    "require_secure_transport"   = "OFF" # turn on SSL later once we get certs sorted
    "log_line_prefix"            = "t=%m u=%u db=%d pid=[%p]" # audit log line format
    "log_statement"              = "none" # dont use normal pg logging
    "pgaudit.log"                = "ALL" # READ is not recommended
    "pgaudit.log_catalog"        = "on" # following a MS PG recommendations
    "pgaudit.log_level"          = "INFO"
    "pgaudit.log_client"         = "ON"
    "pgaudit.Log_parameter"      = "off"
    "pgaudit.Log_relation"       = "off"
    "pgaudit.Log_statement"      = "on"
    "pgaudit.log_statement_once" = "off"
    "azure.extensions"           = "PGAUDIT"
    "shared_preload_libraries"   = "pgaudit" # needs to be lc, so tf doesnt flip/flop
  }
}

output "sku_name" {
  value = "GP_Standard_D2ads_v5"
}

output "sku_tier" {
  value = "GeneralPurpose"
}

output "standby_availability_zone" {
  value = "2"
}

output "start_hour" {
  value = "1"
}

output "start_minute" {
  value = "30"
}

output "storage_autogrow" {
  value = "Disabled"
}

output "storage_tier" {
  value = "P10"
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

output "storage_size_mb" {
  value = "32768"
}

output "timezone" {
  value = "AUS Eastern Standard Time"
}
