resource "azurerm_virtual_machine" "vm" {
  for_each              = toset(var.vm_name)
  name                  = each.value
  location              = var.location
  resource_group_name   = azurerm_resource_group.app.name
  network_interface_ids = [azurerm_network_interface.nic[each.key].id]
  size                  = "Standard_D8s_v3"
  admin_username        = "adminuser"
  admin_password        = "Password@123"

  source_image_reference {
    publisher = "openlogic"
    offer     = "CentOS"
    sku       = "7.7"
    version   = "latest"
  }

  storage_os_disk {
    name            =  "${each.key}-osdisk"
    caching           = "ReadWrite"
    create_option   = "FromImage"
    Managed_disk_type   = "Premium_LRS"
    disk_size_gb        = "40"
  }

  storage_data_disk {
    name            =  "${each.key}-disk1"
    caching           = "none"
    create_option   = "Empty"
    Managed_disk_type   = "Premium_LRS"
    disk_size_gb        = "256"
    lun         = 0
  }  
}
