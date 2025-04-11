variable "vm_name" {
  description = "Name of the virtual machine"
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

variable "subnet_id" {
  description = "ID of the subnet where the VM will be deployed"
  type        = string
}

variable "admin_username" {
  description = "Username for the VM"
  type        = string
}

variable "admin_ssh_public_key" {
  description = "Public SSH key for accessing the VM"
  type        = string
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
}

variable "os_disk_type" {
  description = "Disk type for the virtual machine"
  type        = string
}

variable "os_disk_size" {
  description = "Disk size for the virtual machine in GB"
  type        = number
}

variable "tags" {
  description = "Tags to apply to the resources"
  type        = map(string)
  default     = {}
}