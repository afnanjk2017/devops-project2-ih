resource "azurerm_monitor_action_group" "m_ag" {
  name                = "CriticalAlertsAction"
  resource_group_name = var.rg_name
  short_name          = "to_admin"

  email_receiver {
    name          = var.contact_person_name
    email_address = var.contact_person_email
  }
  webhook_receiver {
    service_uri             = "https://discord.com/api/webhooks/1419214039774396487/SvRpbDhADj0E-mtvyHXAivI-I_w019LJ69Jec9SzMxTniL70LIvo3zYZMuCGfphDysdj"
    name                    = "${var.contact_person_name}-discord"
    use_common_alert_schema = true
  }
}

resource "azurerm_monitor_metric_alert" "sql_cpu" {
  name                = "sql-cpu-metricalert"
  resource_group_name = var.rg_name
  scopes              = [var.db_id]
  description         = "Action will be triggered when SQL Database CPU Utilization is greater than 80."
  severity            = 3

  criteria {
    metric_namespace = "Microsoft.Sql/servers/databases"
    metric_name      = "cpu_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80

    skip_metric_validation = false
  }

  frequency   = "PT1M"
  window_size = "PT5M"

  action {
    action_group_id = azurerm_monitor_action_group.m_ag.id
  }
}

resource "azurerm_monitor_metric_alert" "cpu" {
  for_each = {
    "fe" = var.fe_app_id
    "be" = var.be_app_id
  }

  name                = "${each.key}-cpu-metricalert"
  resource_group_name = var.rg_name
  scopes              = [each.value]
  description         = "Action will be triggered when ${upper(each.key)} CPU Time exceeds 300 seconds in 5 minutes."
  severity            = 3

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "CpuTime"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 300 # 300 seconds (5 minutes) of CPU time in a 5-minute window indicates high usage
  }

  frequency   = "PT1M"
  window_size = "PT5M"

  action {
    action_group_id = azurerm_monitor_action_group.m_ag.id
  }
}

resource "azurerm_monitor_metric_alert" "memory" {
  for_each = {
    fe = var.fe_app_id
    be = var.be_app_id
  }
  name                = "${each.key}-memory-metricalert"
  resource_group_name = var.rg_name
  scopes              = [each.value]
  description         = "Action will be triggered when Memory Working Set exceeds 1GB."
  severity            = 3

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "MemoryWorkingSet"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 1073741824 # 1GB in bytes
  }

  frequency   = "PT1M"
  window_size = "PT5M"

  action {
    action_group_id = azurerm_monitor_action_group.m_ag.id
  }
}

resource "azurerm_monitor_metric_alert" "http_errors" {
  for_each = {
    be = var.be_app_id
    fe = var.fe_app_id
  }
  name                = "${each.key}-http-errors-metricalert"
  resource_group_name = var.rg_name
  scopes              = [each.value]
  description         = "Action will be triggered when HTTP 5xx errors exceed 10 in 5 minutes."
  severity            = 4

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "Http5xx"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 10
  }

  frequency   = "PT1M"
  window_size = "PT5M"

  action {
    action_group_id = azurerm_monitor_action_group.m_ag.id
  }
}

resource "azurerm_monitor_metric_alert" "http_4xx_errors" {
  for_each = {
    be = var.be_app_id
    fe = var.fe_app_id
  }
  name                = "${each.key}-http-4xx-errors-metricalert"
  resource_group_name = var.rg_name
  scopes              = [each.value]
  description         = "Action will be triggered when HTTP 4xx errors exceed 50 in 5 minutes."
  severity            = 4

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "Http4xx"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 50
  }

  frequency   = "PT1M"
  window_size = "PT5M"

  action {
    action_group_id = azurerm_monitor_action_group.m_ag.id
  }
}

# Response time alert
resource "azurerm_monitor_metric_alert" "response_time" {
  for_each = {
    be = var.be_app_id
    fe = var.fe_app_id
  }
  name                = "${each.key}-response-time-metricalert"
  resource_group_name = var.rg_name
  scopes              = [each.value]
  description         = "Action will be triggered when average response time exceeds 10 seconds."
  severity            = 3

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "HttpResponseTime"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 10
  }

  frequency   = "PT1M"
  window_size = "PT5M"

  action {
    action_group_id = azurerm_monitor_action_group.m_ag.id
  }
}

resource "azurerm_monitor_autoscale_setting" "sp_autoscale_be" {
  name                = "${var.service_plan_be_name}-autoscaler"
  resource_group_name = var.rg_name
  location            = var.rg_location
  target_resource_id  = var.service_plan_be_id

  profile {
    name = "default"
    capacity {
      default = 1
      minimum = 1
      maximum = 10
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = var.service_plan_be_id
        time_grain         = "PT1M" # 1 minute
        statistic          = "Average"
        time_window        = "PT1M" # 5 minutes
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 80
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"    # Add 1 instance
        cooldown  = "PT5M" # Wait 5 minutes before next scale action
      }
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = var.service_plan_be_id
        time_grain         = "PT1M" # 1 minute
        statistic          = "Average"
        time_window        = "PT10M" # 10 minutes
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 30
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"     # Remove 1 instance
        cooldown  = "PT10M" # Wait 10 minutes before next scale action
      }
    }

    # Memory-based scaling rule
    rule {
      metric_trigger {
        metric_name        = "MemoryPercentage"
        metric_resource_id = var.service_plan_be_id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 85
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "MemoryPercentage"
        metric_resource_id = var.service_plan_be_id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT10M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 40
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT10M"
      }
    }
  }

  notification {
    email {
      send_to_subscription_administrator    = false
      send_to_subscription_co_administrator = false
      custom_emails                         = [var.contact_person_email]
    }
    webhook {
      service_uri = "https://discord.com/api/webhooks/1419214039774396487/SvRpbDhADj0E-mtvyHXAivI-I_w019LJ69Jec9SzMxTniL70LIvo3zYZMuCGfphDysdj"
    }
  }
}
resource "azurerm_monitor_autoscale_setting" "sp_autoscale_fe" {
  name                = "${var.service_plan_fe_name}-autoscaler"
  resource_group_name = var.rg_name
  location            = var.rg_location
  target_resource_id  = var.service_plan_fe_id

  profile {
    name = "default"
    capacity {
      default = 1
      minimum = 1
      maximum = 10
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = var.service_plan_fe_id
        time_grain         = "PT1M" # 1 minute
        statistic          = "Average"
        time_window        = "PT1M" # 5 minutes
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 80
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"    # Add 1 instance
        cooldown  = "PT5M" # Wait 5 minutes before next scale action
      }
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = var.service_plan_fe_id
        time_grain         = "PT1M" # 1 minute
        statistic          = "Average"
        time_window        = "PT10M" # 10 minutes
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 30
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"     # Remove 1 instance
        cooldown  = "PT10M" # Wait 10 minutes before next scale action
      }
    }

    # Memory-based scaling rule
    rule {
      metric_trigger {
        metric_name        = "MemoryPercentage"
        metric_resource_id = var.service_plan_fe_id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 85
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "MemoryPercentage"
        metric_resource_id = var.service_plan_fe_id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT10M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 40
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT10M"
      }
    }
  }

  notification {
    email {
      send_to_subscription_administrator    = false
      send_to_subscription_co_administrator = false
      custom_emails                         = [var.contact_person_email]
    }
    webhook {
      service_uri = "https://discord.com/api/webhooks/1419214039774396487/SvRpbDhADj0E-mtvyHXAivI-I_w019LJ69Jec9SzMxTniL70LIvo3zYZMuCGfphDysdj"
    }
  }
}

resource "azurerm_application_insights" "app_insights" {
  name                = "app-insights"
  location            = var.rg_location
  resource_group_name = var.rg_name
  application_type    = "Node.JS"
  workspace_id        = azurerm_log_analytics_workspace.log_ws.id
  retention_in_days   = 30
}
resource "azurerm_log_analytics_workspace" "log_ws" {
  name                = "log-ws"
  location            = var.rg_location
  resource_group_name = var.rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
