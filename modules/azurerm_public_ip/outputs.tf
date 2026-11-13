output "public_ip_ids" {
  description = "IDs of the deployed Public IPs"
  value       = { for k, v in azurerm_public_ip.pip : k => v.id }
}

output "public_ip_addresses" {
  description = "IP addresses of the deployed Public IPs"
  value       = { for k, v in azurerm_public_ip.pip : k => v.ip_address }
}
