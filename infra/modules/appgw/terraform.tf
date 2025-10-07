resource "azurerm_application_gateway" "agw" {
  name                = "${lower(var.resource_prefix)}-agw-${lower(replace(var.author, " ", "-"))}"
  resource_group_name = var.rg_name
  location            = var.rg_location
  depends_on          = [var.fe_app_id, var.be_app_id]

  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
  }

  waf_configuration {
    enabled          = true
    firewall_mode    = "Prevention"
    rule_set_version = "3.0"
  }

  autoscale_configuration {
    min_capacity = 1
    max_capacity = 20
  }

  gateway_ip_configuration {
    name      = "agw-ip-config"
    subnet_id = var.subnet_agw_id
  }
  frontend_port {
    port = 80
    name = local.frontend_port_name
  }
  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.agw_pip.id
  }
  backend_address_pool {
    name = local.backend_address_pool_name_be

    fqdns = [var.be_app_fqdn]
  }
  backend_address_pool {
    name = local.backend_address_pool_name_fe

    fqdns = [var.fe_app_fqdn]
  }

  backend_http_settings {
    name                  = local.http_setting_name_fe
    cookie_based_affinity = "Disabled"

    protocol                            = "Http"
    request_timeout                     = 60
    port                                = local.http_port
    pick_host_name_from_backend_address = true
    probe_name                          = local.pe_probe_fe
  }
  backend_http_settings {
    name                  = local.http_setting_name_be
    cookie_based_affinity = "Disabled"
    protocol              = "Http"
    request_timeout       = 60
    # Changed
    port                                = local.http_port
    pick_host_name_from_backend_address = true
    probe_name                          = local.pe_probe_be
  }

  http_listener {
    protocol                       = "Http"
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
  }
  url_path_map {
    name                               = local.pm_name
    default_backend_address_pool_name  = local.backend_address_pool_name_fe
    default_backend_http_settings_name = local.http_setting_name_fe
    path_rule {
      paths                      = ["/*"]
      backend_address_pool_name  = local.backend_address_pool_name_fe
      backend_http_settings_name = local.http_setting_name_fe
      name                       = "redir-to-fe"
    }
    path_rule {
      paths                      = ["/api/*"]
      backend_address_pool_name  = local.backend_address_pool_name_be
      backend_http_settings_name = local.http_setting_name_be
      name                       = "redir-to-be"
    }
  }
  request_routing_rule {
    name                       = local.request_routing_rule_name_be
    priority                   = 100
    rule_type                  = "PathBasedRouting"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name_fe
    backend_http_settings_name = local.backend_address_pool_name_fe
    url_path_map_name          = local.pm_name
  }

  probe {
    interval                                  = 120
    name                                      = local.pe_probe_be
    port                                      = var.be_port
    path                                      = "/api/health"
    timeout                                   = 60
    unhealthy_threshold                       = 3
    pick_host_name_from_backend_http_settings = true
    protocol                                  = "Http"
  }
  probe {
    interval                                  = 60
    name                                      = local.pe_probe_fe
    port                                      = var.fe_port
    path                                      = "/"
    timeout                                   = 60
    unhealthy_threshold                       = 3
    pick_host_name_from_backend_http_settings = true
    protocol                                  = "Http"
  }
}

resource "azurerm_public_ip" "agw_pip" {
  name                = "${lower(var.resource_prefix)}-agw-pip-${lower(replace(var.author, " ", "-"))}"
  resource_group_name = var.rg_name
  location            = var.rg_location
  allocation_method   = "Static"

}


locals {
  backend_address_pool_name_be   = "${var.vnet_name}-beap-be"
  backend_address_pool_name_fe   = "${var.vnet_name}-beap-fe"
  frontend_port_name             = "${var.vnet_name}-feport"
  frontend_ip_configuration_name = "${var.vnet_name}-feip"
  http_setting_name_be           = "${var.vnet_name}-be-htst-be"
  http_setting_name_fe           = "${var.vnet_name}-be-htst-fe"
  listener_name                  = "${var.vnet_name}-httplstn"
  request_routing_rule_name_fe   = "${var.vnet_name}-rqrt-fe"
  request_routing_rule_name_be   = "${var.vnet_name}-rqrt-be"
  redirect_configuration_name    = "${var.vnet_name}-rdrcfg"
  pm_name                        = "${var.vnet_name}-path-map"
  pe_probe_be                    = "${var.vnet_name}-be-probe"
  pe_probe_fe                    = "${var.vnet_name}-fe-probe"
  http_port                      = 80
  https_port                     = 443
}
