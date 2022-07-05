#idea is to use the new version of the azurerm providers
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# default feature of the code
provider "azurerm" {
  features {}
}

# Adding the resource_group for sweet state file a resource group
resource "azurerm_resource_group" "stategroup" {
  name     = "state-resource-group"
  location = "West Europe"
}
resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}
resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstate${random_string.resource_code.result}"
  resource_group_name      = azurerm_resource_group.stategroup.name
  location                 = azurerm_resource_group.stategroup.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = true

  tags = {
    environment = "development"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "blob"
}
resource "azurerm_storage_container" "tfstateaks" {
  name                  = "tfstateaks"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "blob"
}