terraform {
  backend "azurerm" {
    resource_group_name  = var.storage_rq
    storage_account_name = var.storage_ac
    container_name       = var.blob_con
    key                  = var.keytf
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
