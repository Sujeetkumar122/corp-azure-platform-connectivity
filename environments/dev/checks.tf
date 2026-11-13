# ==============================================================================
# Connectivity Security Guardrails (100% Pure HCL)
# ==============================================================================

# Guardrail 1: Enforce Standard SKU for Public IPs
check "enforce_pip_sku" {
  assert {
    condition = alltrue([
      for k, v in var.public_ips : v.sku == "Standard"
    ])
    error_message = "Enterprise Policy: All public IP addresses must use Standard SKU."
  }
}

# Guardrail 2: Enforce minimum capacity for Application Gateway
check "enforce_appgw_capacity" {
  assert {
    condition = alltrue([
      for k, v in var.application_gateways : v.capacity >= 2
    ])
    error_message = "Enterprise Policy: Application Gateway must deploy with high availability capacity >= 2."
  }
}
