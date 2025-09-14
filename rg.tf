resource "azurerm_resource_group" "psql_fs_ec" {
  location = module.global.location
  name     = "psql-fs-ec"
}