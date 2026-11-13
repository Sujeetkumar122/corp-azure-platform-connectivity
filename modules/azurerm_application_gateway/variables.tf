variable "application_gateways" {
  description = "Map of Azure Application Gateways (Front Gate) to deploy"
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    sku_name            = optional(string, "Standard_v2")
    sku_tier            = optional(string, "Standard_v2")
    capacity            = optional(number, 2)
    subnet_id           = string
    public_ip_id        = string
    tags                = optional(map(string), {})
  }))
}
