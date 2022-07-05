output "name" {
  description = "Name of the storage account created."
  value       = azurerm_storage_account.tfstate.name
}