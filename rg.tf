resource "azurerm_resource_group" "rg" {
  location = module.global.location
  name     = "psql-fs-ec"
}