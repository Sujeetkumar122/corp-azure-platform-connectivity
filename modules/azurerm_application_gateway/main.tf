resource "azurerm_application_gateway" "appgw" {
  for_each = var.application_gateways

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  sku {
    name     = try(each.value.sku_name, "Standard_v2")
    tier     = try(each.value.sku_tier, "Standard_v2")
    capacity = try(each.value.capacity, 2)
  }

  gateway_ip_configuration {
    name      = "${each.value.name}-gw-ipcfg"
    subnet_id = each.value.subnet_id
  }

  frontend_port {
    name = "http-port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "appgw-public-fe"
    public_ip_address_id = each.value.public_ip_id
  }

  backend_address_pool {
    name = "default-backend-pool"
  }

  backend_http_settings {
    name                  = "http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }

  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "appgw-public-fe"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "http-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "http-listener"
    backend_address_pool_name  = "default-backend-pool"
    backend_http_settings_name = "http-settings"
    priority                   = 100
  }

  tags = try(each.value.tags, {})
}
