resource "azurerm_resource_group" "app" {
  name = "Kubernetes-terraform-app-rg"
  location = var.location
}
resource "azurerm_resource_group" "net" {
  name = "Kubernetes-terraform-net-rg"
  location = var.location
}