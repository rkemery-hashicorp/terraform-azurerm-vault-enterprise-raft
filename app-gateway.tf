locals {
  backend_address_pool_name         = format("%s-beap", var.environment)
  app_frontend_port_name            = format("%s-app-feport", var.environment)
  frontend_ip_configuration_name    = format("%s-feip", var.environment)
  app_http_setting_name             = format("%s-app-htst", var.environment)
  app_listener_name                 = format("%s-app-httplstn", var.environment)
  app_request_routing_rule_name     = format("%s-app-rqrt", var.environment)
  redirect_configuration_name       = format("%s-rdrcfg", var.environment)
  app_probe_name                    = format("%s-app-probe", var.environment)
  gateway_ip_configuration_name     = format("%s-ip-configuration", var.environment)
}

resource "random_pet" "endpoint" {
  length = 2
}

resource "azurerm_public_ip" "appgateway" {
  resource_group_name = azurerm_resource_group.vault.name
  location            = var.location
  name                = format("%s-appgateway-pubip", var.environment)
  allocation_method   = "Static"
  domain_name_label   = random_pet.endpoint.id
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "appgateway" {
  resource_group_name = azurerm_resource_group.vault.name
  location            = var.location
  name                = format("%s-appgateway", var.environment)

  # WAF_v2 or Standard_v2
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = local.gateway_ip_configuration_name
    subnet_id = azurerm_subnet.appgateway.id
  }

  frontend_port {
    name = local.app_frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.appgateway.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.app_http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = var.backend_http_port
    protocol              = "Http"
    request_timeout       = 60
    # host_name             = azurerm_linux_virtual_machine.vault[count.index].name
    probe_name            = local.app_probe_name
  }

  http_listener {
    name                           = local.app_listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.app_frontend_port_name
    protocol                       = "Http"
  }

  probe {
    name                                      = local.app_probe_name
    pick_host_name_from_backend_http_settings = true
    protocol                                  = "Http"
    path                                      = "/"
    interval                                  = 2
    timeout                                   = 5
    unhealthy_threshold                       = 3
  }

  request_routing_rule {
    name                       = local.app_request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.app_listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.app_http_setting_name
  }
}
