
resource "random_string" "psql" {
  length  = 15
  special = true
  numeric = true
  lower   = true
  upper   = true
}

resource "azurerm_key_vault_secret" "psql_pass" {
  key_vault_id = data.azurerm_key_vault.kv.id
  name         = "ecuser"
  value        = random_string.psql.result
}

