output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}
output "private_endpoint_subnet_id" {
  value = azurerm_virtual_network.vnet.subnet
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}
