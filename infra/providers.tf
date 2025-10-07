terraform {
  backend "azurerm" {
    resource_group_name  = "devops-afnan-storage-rg"
    storage_account_name = "project2afnanstorage"
    container_name       = "terraformstate"
    key                  = "terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.26.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  subscription_id = var.ARM_SUBSCRIPTION_ID
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
