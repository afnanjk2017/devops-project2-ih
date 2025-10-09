output "insghtsKey_fe" {
  value = azurerm_application_insights.fe_app_insights.instrumentation_key
}
output "connect_fe" {
  value = azurerm_application_insights.fe_app_insights.connection_string
}
output "insghtsKey_be" {
  value = azurerm_application_insights.be_app_insights.instrumentation_key
}
output "connect_be" {
  value = azurerm_application_insights.be_app_insights.connection_string
}
