resource "azurerm_subnet" "subnet" {
  name = "Kubernetes-terraform-Subnet"
  resource_group_name =  azurerm_resource_group.net.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix = "10.0.1.0/24"
}