variable "environment" {
  description = "Environment (dev, test, prod)"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "tier" {
  description = "Storage account tier (Standard or Premium)"
  type        = string
  default     = "Standard"
}

variable "replication_type" {
  description = "Replication type for the storage account"
  type        = string
  default     = "LRS"
}

variable "subnet_ids" {
  description = "List of subnet IDs allowed to access the storage account"
  type        = list(string)
}

variable "admin_ip_address" {
  description = "Administrator IP address for access rules"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the resources"
  type        = map(string)
  default     = {}
}