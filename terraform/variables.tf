variable "environment" {
  description = "Entorno (dev, test, prod)"
  type        = string
}

variable "location" {
  description = "Región de Azure donde se desplegarán los recursos"
  type        = string
}

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "vnet_address_space" {
  description = "Espacio de direcciones para la red virtual"
  type        = list(string)
}

variable "subnets" {
  description = "Lista de configuraciones de subredes para crear dentro de la VNET"
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
}

variable "admin_username" {
  description = "Nombre de usuario para la máquina virtual"
  type        = string
}

variable "admin_ssh_public_key" {
  description = "Clave SSH pública para el acceso a la máquina virtual"
  type        = string
  sensitive   = true
}

variable "admin_ip_address" {
  description = "Dirección IP del administrador para reglas de acceso"
  type        = string
}

variable "vm_size" {
  description = "Tamaño de la máquina virtual"
  type        = string
}

variable "vm_disk_type" {
  description = "Tipo de disco para la máquina virtual"
  type        = string
}

variable "vm_disk_size" {
  description = "Tamaño del disco para la máquina virtual en GB"
  type        = number
}

variable "storage_account_tier" {
  description = "Nivel de la cuenta de almacenamiento (Standard o Premium)"
  type        = string
}

variable "storage_account_replication_type" {
  description = "Tipo de replicación para la cuenta de almacenamiento"
  type        = string
}

variable "create_key_vault" {
  description = "Indica si se debe crear un Key Vault"
  type        = bool
  default     = false
}