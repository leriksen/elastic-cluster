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

output "standby_availability_zone" {
  value = "2"
}

output "sku_name" {
  value = "GP_Standard_D4ads_v5"
}

output "sku_tier" {
  value = "GeneralPurpose"
}

output "storage_autogrow" {
  value = "Disabled"
}

output "storage_autogrow_bool" {
  value = false
}

output "server_configs" {
  value = {
    require_secure_transport = "OFF"

  }
}

output "storage_size_gb" {
  value = "32"
}

output "storage_size_mb" {
  value = "32768"
}
