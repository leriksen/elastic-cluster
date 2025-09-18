resource "azurerm_virtual_network" "vnet" {
  location            = azurerm_resource_group.rg.location
  name                = "vnet01"
  resource_group_name = azurerm_resource_group.rg.name
  address_space = [
    "10.0.0.0/16"
  ]
}

resource "azurerm_subnet" "pe01" {
  address_prefixes = [
    "10.0.0.0/24"
  ]
  name                 = "pe01"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_network_security_group" "nsg01" {
  name                = "nsg01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "pe01_nsg01" {
  network_security_group_id = azurerm_network_security_group.nsg01.id
  subnet_id                 = azurerm_subnet.pe01.id
}

resource "azurerm_network_security_rule" "psql_in" {
  name                        = "in_allow_psql"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5432"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg01.name
}

resource "azurerm_network_security_rule" "ssh_in" {
  name                        = "in_allow_ssh"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg01.name
}

resource "azurerm_private_dns_zone" "psql" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_zone" {
  name                  = "psql_private_dns_zone"
  private_dns_zone_name = azurerm_private_dns_zone.psql.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  resource_group_name   = azurerm_resource_group.rg.name
  depends_on = [
    azurerm_subnet.pe01
  ]
}

resource "azurerm_network_interface" "nic01" {
  name                = "nic01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "public"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.pe01.id
    public_ip_address_id          = azurerm_public_ip.ip01.id
  }
}

resource "azurerm_public_ip" "ip01" {
  location            = azurerm_resource_group.rg.location
  name                = "ip01"
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

