resource "azurerm_lb" "lb" {
  for_each = var.load_balancers

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = try(each.value.sku, "Standard")

  frontend_ip_configuration {
    name                          = "${each.value.name}-fe"
    public_ip_address_id          = try(each.value.public_ip_address_id, null)
    subnet_id                     = try(each.value.subnet_id, null)
    private_ip_address_allocation = try(each.value.private_ip_address_allocation, "Dynamic")
  }

  tags = try(each.value.tags, {})
}

resource "azurerm_lb_backend_address_pool" "pool" {
  for_each = var.load_balancers

  loadbalancer_id = azurerm_lb.lb[each.key].id
  name            = "${each.value.name}-backend-pool"
}

resource "azurerm_lb_probe" "probe" {
  for_each = var.load_balancers

  loadbalancer_id = azurerm_lb.lb[each.key].id
  name            = "${each.value.name}-health-probe"
  port            = try(each.value.probe_port, 80)
  protocol        = try(each.value.probe_protocol, "Http")
  request_path    = try(each.value.probe_path, "/health")
}

resource "azurerm_lb_rule" "rule" {
  for_each = var.load_balancers

  loadbalancer_id                = azurerm_lb.lb[each.key].id
  name                           = "${each.value.name}-lb-rule"
  protocol                       = "Tcp"
  frontend_port                  = try(each.value.frontend_port, 80)
  backend_port                   = try(each.value.backend_port, 80)
  frontend_ip_configuration_name = "${each.value.name}-fe"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.pool[each.key].id]
  probe_id                       = azurerm_lb_probe.probe[each.key].id
}
