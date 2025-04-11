variable "vnet_name" {
  description = "Virtual Network Name"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group where the VNET will be created"
  type        = string
}

variable "location" {
  description = "Azure region where the VNET will be created"
  type        = string
}

variable "address_space" {
  description = "List of address spaces for the VNET"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "dns_servers" {
  description = "Optional list of custom DNS servers"
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = "Subnet map to create within the VNET"
  type = list(object({
    name           = string
    address_prefix = string
    service_endpoints = optional(list(string), [])
    create_nsg     = optional(bool, false)
    nsg_rules      = optional(map(object({
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = optional(string)
      destination_port_range     = optional(string)
      source_address_prefix      = optional(string)
      destination_address_prefix = optional(string)
    })), {})
    delegation     = optional(object({
      name                      = string
      service_delegation_name   = string
      service_delegation_actions = optional(list(string))
    }), {})
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}