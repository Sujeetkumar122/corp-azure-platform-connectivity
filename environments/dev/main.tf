# ==============================================================================
# 1. Resource Groups
# ==============================================================================
module "rg" {
  source = "../../modules/azurerm_resource_group"

  resource_groups = var.resource_groups
}

# ==============================================================================
# 2. Virtual Networks & Subnets
# ==============================================================================
module "vnet" {
  source     = "../../modules/azurerm_virtual_network"
  depends_on = [module.rg]

  vnets = {
    for k, v in var.vnets : k => {
      name                = v.name
      location            = module.rg.resource_group_locations[v.rg_key]
      resource_group_name = module.rg.resource_group_names[v.rg_key]
      address_space       = v.address_space
      tags                = v.tags
    }
  }

  subnets = {
    for k, v in var.subnets : k => {
      name                = v.name
      vnet_key            = v.vnet_key
      resource_group_name = module.rg.resource_group_names[v.rg_key]
      prefix              = v.prefix
    }
  }
}

# ==============================================================================
# 3. Public IPs (Standard Static for App Gateway & Load Balancer)
# ==============================================================================
module "public_ip" {
  source     = "../../modules/azurerm_public_ip"
  depends_on = [module.rg]

  public_ips = {
    for k, v in var.public_ips : k => {
      name                = v.name
      location            = module.rg.resource_group_locations[v.rg_key]
      resource_group_name = module.rg.resource_group_names[v.rg_key]
      allocation_method   = v.allocation_method
      sku                 = v.sku
      tags                = v.tags
    }
  }
}

# ==============================================================================
# 4. Public Load Balancer
# ==============================================================================
module "load_balancer" {
  source     = "../../modules/azurerm_lb"
  depends_on = [module.public_ip]

  load_balancers = {
    for k, v in var.load_balancers : k => {
      name                 = v.name
      location             = module.rg.resource_group_locations[v.rg_key]
      resource_group_name  = module.rg.resource_group_names[v.rg_key]
      sku                  = "Standard"
      public_ip_address_id = module.public_ip.public_ip_ids[v.pip_key]
      probe_port           = v.probe_port
      tags                 = v.tags
    }
  }
}

# ==============================================================================
# 5. Application Gateway (Front Gate / WAF)
# ==============================================================================
module "application_gateway" {
  source     = "../../modules/azurerm_application_gateway"
  depends_on = [module.vnet, module.public_ip]

  application_gateways = {
    for k, v in var.application_gateways : k => {
      name                = v.name
      resource_group_name = module.rg.resource_group_names[v.rg_key]
      location            = module.rg.resource_group_locations[v.rg_key]
      sku_name            = "Standard_v2"
      sku_tier            = "Standard_v2"
      capacity            = v.capacity
      subnet_id           = module.vnet.subnet_ids[v.subnet_key]
      public_ip_id        = module.public_ip.public_ip_ids[v.pip_key]
      tags                = v.tags
    }
  }
}
