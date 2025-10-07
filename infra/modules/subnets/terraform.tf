
resource "azurerm_subnet" "private_endpoints" {
  name                              = "pe-subnet-private"
  resource_group_name               = var.rg_name
  virtual_network_name              = var.vnet_name
  depends_on                        = [var.rg_id, var.vnet_id]
  address_prefixes                  = ["10.0.1.0/24"]
  service_endpoints                 = ["Microsoft.Web"]
  private_endpoint_network_policies = "Enabled"
}
resource "azurerm_subnet" "agw_subnet" {
  name                 = "agw-subnet-public"
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  depends_on           = [var.rg_id, var.vnet_id]
  address_prefixes     = ["10.0.50.0/24"]
  service_endpoints    = ["Microsoft.Web"]
}
resource "azurerm_subnet" "db_subnet" {
  name                 = "db-subnet-private"
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  depends_on           = [var.rg_id, var.vnet_id]
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Sql"]
}
resource "azurerm_subnet" "fe_subnet" {
  name                 = "fe-subnet-private"
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  depends_on           = [var.rg_id, var.vnet_id]
  address_prefixes     = ["10.0.8.0/24"]
  service_endpoints    = ["Microsoft.Web"]
  # VNET delegation
  delegation {
    name = "Microsoft.Web.serverFarms"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}
resource "azurerm_subnet" "be_subnet" {
  name                 = "be-subnet-private"
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  depends_on           = [var.rg_id, var.vnet_id]
  address_prefixes     = ["10.0.20.0/24"]
  service_endpoints    = ["Microsoft.Web", "Microsoft.Sql"]
  # VNET delegation
  delegation {
    name = "Microsoft.Web.serverFarms"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}
