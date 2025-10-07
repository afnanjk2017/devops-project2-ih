# --- MSSQL server setup ---
resource "azurerm_mssql_server" "products_db_server" {
  name                          = "${lower(var.resource_prefix)}-db-server-${lower(replace(var.author, " ", "-"))}"
  resource_group_name           = var.rg_name
  location                      = var.rg_location
  version                       = "12.0"
  administrator_login           = var.db_admin
  administrator_login_password  = var.db_password
  depends_on                    = [var.rg_id]
  public_network_access_enabled = false
}

# --- DB setup ---
resource "azurerm_mssql_database" "products_db" {
  name                        = "${lower(var.resource_prefix)}-db-${lower(replace(var.author, " ", "-"))}"
  server_id                   = azurerm_mssql_server.products_db_server.id
  depends_on                  = [azurerm_mssql_server.products_db_server]
  collation                   = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb                 = 4
  sample_name                 = "AdventureWorksLT"
  sku_name                    = "GP_S_Gen5_1" # Serverless
  auto_pause_delay_in_minutes = 60
  min_capacity                = 0.5
}

# --- Private DNS Zone ---
resource "azurerm_private_dns_zone" "sql_zone" {
  name                = "privatelink.database.windows.net"
  resource_group_name = var.rg_name
}
# --- Private DNS Zone link to Vnet ---
resource "azurerm_private_dns_zone_virtual_network_link" "pdns_vnet_link" {
  name                  = "pdns-vnet-link"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.sql_zone.name
  virtual_network_id    = var.vnet_id
}
# --- Private Endpoint ---
resource "azurerm_private_endpoint" "sql_pe" {
  name                = "sql-private-endpoint"
  location            = var.rg_location
  resource_group_name = var.rg_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "sql-connection-private"
    private_connection_resource_id = azurerm_mssql_server.products_db_server.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "sql-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql_zone.id]
  }

}
