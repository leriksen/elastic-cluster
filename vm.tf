# resource "azurerm_linux_virtual_machine" "vm02" {
#   name                = "vm02"
#   resource_group_name = data.azurerm_resource_group.rg.name
#   location            = data.azurerm_resource_group.rg.location
#   size                = "Standard_D2s_v3"
#   admin_username      = "adminuser"
#   network_interface_ids = [
#     azurerm_network_interface.nic01.id,
#   ]
#
#   admin_ssh_key {
#     username   = "adminuser"
#     public_key = file("~/.ssh/id_rsa.pub")
#   }
#
#   identity {
#     type = "SystemAssigned"
#   }
#
#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }
#
#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "ubuntu-24_04-lts"
#     sku       = "server"
#     version   = "latest"
#   }
#
#   priority        = "Spot"
#   eviction_policy = "Deallocate"
# }