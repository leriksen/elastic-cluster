resource "azurerm_log_analytics_workspace" "law" {
  location            = azurerm_resource_group.rg.location
  name                = "psql-law01"
  resource_group_name = azurerm_resource_group.rg.name
}