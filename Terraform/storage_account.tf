resource "azurerm_storage_account" "storage" {
  name = "Kubernetes-terraform-storage"
  location = var.location
  account_tier = "standard"
  account_replication_type = "LRS"
}