variable "environment" {
  description = "Target deployment environment"
  type        = string
  default     = "dev"
}

variable "resource_groups" {
  description = "Map of resource groups to deploy"
  type = map(object({
    name     = string
    location = string
    tags     = optional(map(string), {})
  }))
}

variable "vnets" {
  description = "Map of virtual networks to deploy"
  type = map(object({
    name          = string
    rg_key        = string
    address_space = list(string)
    tags          = optional(map(string), {})
  }))
}

variable "subnets" {
  description = "Map of subnets to deploy"
  type = map(object({
    name     = string
    vnet_key = string
    rg_key   = string
    prefix   = string
  }))
}

variable "public_ips" {
  description = "Map of public IP addresses"
  type = map(object({
    name              = string
    rg_key            = string
    allocation_method = optional(string, "Static")
    sku               = optional(string, "Standard")
    tags              = optional(map(string), {})
  }))
}

variable "load_balancers" {
  description = "Map of load balancers"
  type = map(object({
    name       = string
    rg_key     = string
    pip_key    = string
    probe_port = optional(number, 80)
    tags       = optional(map(string), {})
  }))
  default = {}
}

variable "application_gateways" {
  description = "Map of application gateways (Front Gate)"
  type = map(object({
    name       = string
    rg_key     = string
    subnet_key = string
    pip_key    = string
    capacity   = optional(number, 2)
    tags       = optional(map(string), {})
  }))
  default = {}
}
