output "environment" {
  description = "Target deployment environment"
  value       = var.environment
}

output "hub_vnet_ids" {
  description = "IDs of the deployed Hub Virtual Networks"
  value       = module.vnet.vnet_ids
}

output "hub_subnet_ids" {
  description = "IDs of the deployed Subnets"
  value       = module.vnet.subnet_ids
}

output "public_ip_addresses" {
  description = "Public IP addresses for ingress gateways"
  value       = module.public_ip.public_ip_addresses
}

output "load_balancer_ids" {
  description = "IDs of the deployed Load Balancers"
  value       = module.load_balancer.load_balancer_ids
}

output "application_gateway_ids" {
  description = "IDs of the deployed Application Gateways (Front Gate)"
  value       = module.application_gateway.application_gateway_ids
}
