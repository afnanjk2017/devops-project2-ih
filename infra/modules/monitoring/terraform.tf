resource "azurerm_monitor_action_group" "action_group" {
  name                = "CriticalAlertsAction"
  resource_group_name = var.rg_name
  short_name          = "to_admin"

  email_receiver {
    name          = var.contact_person_name
    email_address = var.contact_person_email
  }

}

resource "azurerm_application_insights" "fe_app_insights" {
  name                = "fe-app-insights"
  location            = var.rg_location
  resource_group_name = var.rg_name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.log_ws.id
}

resource "azurerm_application_insights" "be_app_insights" {
  name                = "be-app-insights"
  location            = var.rg_location
  resource_group_name = var.rg_name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.log_ws.id
}

resource "azurerm_log_analytics_workspace" "log_ws" {
  name                = "log-ws"
  location            = var.rg_location
  resource_group_name = var.rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
resource "azurerm_monitor_metric_alert" "appgw_health" {
  name                = "AppGateway-Health-Alert"
  resource_group_name = var.rg_name
  scopes              = [var.app_gateway_id]
  description         = "Triggers when App Gateway backend health falls below 100% for 5 minutes."
  severity            = 2
  enabled             = true
  frequency           = "PT1M" # Check every 1 minute
  window_size         = "PT5M" # Evaluate over 5 minutes

  criteria {
    metric_namespace = "Microsoft.Network/applicationGateways"
    metric_name      = "UnhealthyHostCount"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 0
  }

  action {
    action_group_id = azurerm_monitor_action_group.action_group.id
  }
}

resource "azurerm_monitor_metric_alert" "webapp_cpu" {
  for_each = {
    fe = var.fe_app_id
    be = var.be_app_id
  }

  name                = "${each.key}-CPU-Alert"
  resource_group_name = var.rg_name
  scopes              = [each.value]
  description         = "Alert when CPU usage (CpuTime) is high for 5 minutes"

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "CpuTime"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 300 # adjust threshold based on your load (seconds of CPU time over 5 mins)
  }

  window_size   = "PT5M" # 5-minute window
  frequency     = "PT1M" # check every minute
  severity      = 2
  auto_mitigate = true

  action {
    action_group_id = azurerm_monitor_action_group.action_group.id
  }
}
resource "azurerm_monitor_metric_alert" "sql_cpu" {
  name                = "SQL-cpu-Alert"
  resource_group_name = var.rg_name
  scopes              = [var.db_id]
  description         = "Triggers when SQL  vCore utilization exceeds 80%."
  severity            = 3

  criteria {
    metric_namespace = "Microsoft.Sql/servers/databases"
    metric_name      = "cpu_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  frequency   = "PT1M"
  window_size = "PT5M"

  action {
    action_group_id = azurerm_monitor_action_group.action_group.id
  }
}
