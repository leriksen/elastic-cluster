resource "azurerm_key_vault" "kv" {
  location                   = azurerm_resource_group.rg.location
  name                       = "psqlkv01"
  resource_group_name        = azurerm_resource_group.rg.name
  sku_name                   = "standard"
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled   = true
  soft_delete_retention_days = 7
  enable_rbac_authorization  = true

  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "azurerm_role_assignment" "write_keys" {
  principal_id         = data.azurerm_client_config.current.object_id
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Crypto Officer"
}

resource "azurerm_role_assignment" "cmk_user" {
  depends_on = [
    azurerm_key_vault_key.cmk
  ]
  principal_id         = azurerm_user_assigned_identity.umi.principal_id
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
}

resource "azurerm_key_vault_key" "cmk" {
  depends_on = [
    azurerm_role_assignment.write_keys
  ]
  key_vault_id = azurerm_key_vault.kv.id
  name         = "cmk"
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  rotation_policy {
    automatic {
      time_before_expiry = "P30D"
    }


    expire_after         = "P90D"
    notify_before_expiry = "P29D"
  }
}

