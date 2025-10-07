output "db_id" {
  value = azurerm_mssql_database.products_db.id
}
output "db_server" {
  value = azurerm_mssql_server.products_db_server.fully_qualified_domain_name
}

output "db_name" {
  value = azurerm_mssql_database.products_db.name
}

output "db_user" {
  value = azurerm_mssql_server.products_db_server.administrator_login
}

output "db_password" {
  value     = azurerm_mssql_server.products_db_server.administrator_login_password
  sensitive = true
}
output "mssql_server_name" {
  # Hmmmm
  value = azurerm_mssql_server.products_db_server.name
}
