resource "azurerm_user_assigned_identity" "umi" {
  location            = azurerm_resource_group.rg.location
  name                = local.umi_name
  resource_group_name = azurerm_resource_group.rg.name
}