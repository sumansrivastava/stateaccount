# Create your Statefile Space using Terraform

### We are going to use Setup of **Azure Cloud Storgae Account** and **terraform automation suites** to provision them.

1. I would suggest you to plese create your free account on https://azure.microsoft.com/en-in/free/ 
2. Once you have the free account let's understand the scope of the storage account.

![Untitled Diagram drawio](https://user-images.githubusercontent.com/83497662/177265763-377e0493-3c8e-4cf9-8d33-755a3fc02e5b.png)

3. Since, we have this picture illustrated well that to keep our state file we need isolation at container level.
4. In this example we are going to do the same, we are going to create 2 container under storage account.
5. Storgae accounts needs to be globally unique and thus we need some help from random resource generations.
6. Let's now write our code and start with the config.tf to initiate providers of azurerm.
```
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}
```
7. Let's start the storage account creation with the random generation of suffix.
```
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

```
This code has **resource_group**, **random_string**, **Storage_account** and **Containers**

8. Let's output the tfstate bucket name to be used in the Azure Container Instance code.
```
output "name" {
  description = "Name of the storage account created."
  value       = azurerm_storage_account.tfstate.name
}
```
9. Execution of the code will follow terraform init, terraform plan and terraform apply.

### Since we are now able to create our first terraform storage account to host our terraform state file. We will now see how we are going to host the application on Azure Container Instance.
