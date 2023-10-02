terraform {
  backend "azurerm" {
    resource_group_name  = "<azure_resource_group_name>"
    storage_account_name = "<azure_storage_account_name>"
    container_name       = "<state_azure_storage_bucket_name>"
    key                  = "<state_azure_storage_file_name>.tfstate"
  }
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
}
