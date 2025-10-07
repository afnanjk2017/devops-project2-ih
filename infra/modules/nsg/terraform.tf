
locals {
  agw = "${lower(var.resource_prefix)}-agw-nsg-${lower(replace(var.author, " ", "-"))}"
  db  = "${lower(var.resource_prefix)}-db-nsg-${lower(replace(var.author, " ", "-"))}"
  fe  = "${lower(var.resource_prefix)}-fe-nsg-${lower(replace(var.author, " ", "-"))}"
  be  = "${lower(var.resource_prefix)}-be-nsg-${lower(replace(var.author, " ", "-"))}"
  pe  = "${lower(var.resource_prefix)}-pe-nsg-${lower(replace(var.author, " ", "-"))}"
}
resource "azurerm_network_security_group" "nsg_agw" {
  name                = local.agw
  location            = var.rg_location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "allow-http"
    protocol                   = "*"
    source_address_prefix      = "Internet"
    source_port_range          = "*"
    destination_port_ranges    = ["80"]
    destination_address_prefix = "VirtualNetwork"
    access                     = "Allow"
    priority                   = 100
    direction                  = "Inbound"
  }
  security_rule {
    name                       = "allow-https"
    source_address_prefix      = "Internet"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges    = ["443"]
    destination_address_prefix = "VirtualNetwork"
    access                     = "Allow"
    priority                   = 101
    direction                  = "Inbound"
  }
  security_rule {
    name                       = "allow-agw-management"
    source_address_prefix      = "GatewayManager"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges    = ["65200-65535"]
    destination_address_prefix = "*"
    access                     = "Allow"
    priority                   = 102
    direction                  = "Inbound"
  }
}


resource "azurerm_network_security_group" "nsg_be" {
  name                = local.be
  location            = var.rg_location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "allow-http"
    protocol                   = "*"
    source_address_prefixes    = concat(var.subnet_agw_cidr, var.subnet_fe_cidr)
    source_port_range          = "*"
    destination_port_ranges    = ["80"]
    destination_address_prefix = "VirtualNetwork"
    access                     = "Allow"
    priority                   = 100
    direction                  = "Inbound"
  }
  security_rule {
    name                       = "allow-https"
    protocol                   = "*"
    source_address_prefixes    = concat(var.subnet_agw_cidr, var.subnet_fe_cidr)
    source_port_range          = "*"
    destination_port_ranges    = ["443"]
    destination_address_prefix = "VirtualNetwork"
    access                     = "Allow"
    priority                   = 101
    direction                  = "Inbound"
  }
  security_rule {
    name                       = "allow-api-port"
    protocol                   = "*"
    source_address_prefixes    = concat(var.subnet_agw_cidr, var.subnet_fe_cidr)
    source_port_range          = "*"
    destination_port_ranges    = ["3001"]
    destination_address_prefix = "VirtualNetwork"
    access                     = "Allow"
    priority                   = 102
    direction                  = "Inbound"
  }
  security_rule {
    name                       = "allow-fe-port"
    protocol                   = "*"
    source_address_prefixes    = concat(var.subnet_agw_cidr, var.subnet_fe_cidr)
    source_port_range          = "*"
    destination_port_ranges    = [var.fe_port]
    destination_address_prefix = "VirtualNetwork"
    access                     = "Allow"
    priority                   = 104
    direction                  = "Inbound"
  }
  security_rule {
    name                       = "allow-agw-management"
    source_address_prefix      = "GatewayManager"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges    = ["65200-65535"]
    destination_address_prefix = "*"
    access                     = "Allow"
    priority                   = 103
    direction                  = "Inbound"
  }
}
resource "azurerm_network_security_group" "nsg_fe" {
  name                = local.fe
  location            = var.rg_location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "allow-http"
    protocol                   = "*"
    source_address_prefixes    = concat(var.subnet_agw_cidr, var.subnet_be_cidr)
    source_port_range          = "*"
    destination_port_ranges    = ["80"]
    destination_address_prefix = "VirtualNetwork"
    access                     = "Allow"
    priority                   = 100
    direction                  = "Inbound"
  }
  security_rule {
    name                       = "allow-https"
    protocol                   = "*"
    source_address_prefixes    = concat(var.subnet_agw_cidr, var.subnet_be_cidr)
    source_port_range          = "*"
    destination_port_ranges    = ["443"]
    destination_address_prefix = "VirtualNetwork"
    access                     = "Allow"
    priority                   = 101
    direction                  = "Inbound"
  }
  security_rule {
    name                       = "allow-bee-port"
    protocol                   = "*"
    source_address_prefixes    = concat(var.subnet_agw_cidr, var.subnet_fe_cidr)
    source_port_range          = "*"
    destination_port_ranges    = [var.be_port]
    destination_address_prefix = "VirtualNetwork"
    access                     = "Allow"
    priority                   = 102
    direction                  = "Inbound"
  }
  security_rule {
    name                       = "allow-agw-management"
    source_address_prefix      = "GatewayManager"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges    = ["65200-65535"]
    destination_address_prefix = "*"
    access                     = "Allow"
    priority                   = 103
    direction                  = "Inbound"
  }
}
resource "azurerm_network_security_group" "nsg_db" {
  name                = local.db
  location            = var.rg_location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "allow-azure-sql"
    protocol                   = "*"
    source_address_prefixes    = var.subnet_be_cidr
    source_port_range          = "*"
    destination_port_ranges    = ["1433"]
    destination_address_prefix = "VirtualNetwork"
    access                     = "Allow"
    priority                   = 100
    direction                  = "Inbound"
  }
  security_rule {
    name                       = "allow-agw-management"
    source_address_prefix      = "GatewayManager"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges    = ["65200-65535"]
    destination_address_prefix = "*"
    access                     = "Allow"
    priority                   = 103
    direction                  = "Inbound"
  }
}

resource "azurerm_subnet_network_security_group_association" "be_assoc" {
  subnet_id                 = var.subnet_be_id
  network_security_group_id = azurerm_network_security_group.nsg_be.id
}
resource "azurerm_subnet_network_security_group_association" "fe_assoc" {
  subnet_id                 = var.subnet_fe_id
  network_security_group_id = azurerm_network_security_group.nsg_fe.id
}
resource "azurerm_subnet_network_security_group_association" "db_assoc" {
  subnet_id                 = var.subnet_db_id
  network_security_group_id = azurerm_network_security_group.nsg_db.id
}
resource "azurerm_subnet_network_security_group_association" "agw_assoc" {
  subnet_id                 = var.subnet_agw_id
  network_security_group_id = azurerm_network_security_group.nsg_agw.id
}
