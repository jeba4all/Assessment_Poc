resource "azurerm_network_interface" "nic" {
  for_each = toset(var.vm_name)
  name = each.value
  location = var.location
  resource_group_name = azurerm_resource_group.app.name

  ip_configuration {
    name = "ipconfig1"
    subnet_id = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}