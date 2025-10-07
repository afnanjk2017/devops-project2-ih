# output "fe_app_private_ip" {
#   value = azurerm_private_endpoint.fe_pe.private_service_connection[0].private_ip_address
# }

# output "be_app_private_ip" {
#   value = azurerm_private_endpoint.be_pe.private_service_connection[0].private_ip_address
# }
output "service_plan_fe_id" {
  value = azurerm_service_plan.service_plan_fe.id
}
output "service_plan_fe_name" {
  value = azurerm_service_plan.service_plan_fe.name
}
output "service_plan_be_id" {
  value = azurerm_service_plan.service_plan_be.id
}
output "service_plan_be_name" {
  value = azurerm_service_plan.service_plan_be.name
}

output "fe_app_fqdn" {
  value = azurerm_linux_web_app.fe_app.default_hostname
}
output "be_app_fqdn" {
  value = azurerm_linux_web_app.be_app.default_hostname
}

output "fe_app_id" {
  value = azurerm_linux_web_app.fe_app.id
}
output "be_app_id" {
  value = azurerm_linux_web_app.be_app.id
}
