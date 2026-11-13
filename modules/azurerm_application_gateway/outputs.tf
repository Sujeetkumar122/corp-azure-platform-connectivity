output "application_gateway_ids" {
  description = "IDs of the deployed Application Gateways"
  value       = { for k, v in azurerm_application_gateway.appgw : k => v.id }
}

output "backend_pool_ids" {
  description = "IDs of default backend address pools"
  value       = { for k, v in azurerm_application_gateway.appgw : k => v.backend_address_pool[0].id }
}
