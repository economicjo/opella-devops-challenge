output "vnet_id" {
  description = "ID of the created virtual network"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "Name of the created virtual network"
  value       = azurerm_virtual_network.vnet.name
}

output "vnet_address_space" {
  description = "Address space of the virtual network"
  value       = azurerm_virtual_network.vnet.address_space
}

output "subnet_ids" {
  description = "Map of subnet names to their IDs"
  value       = { for subnet_key, subnet in azurerm_subnet.subnet : subnet_key => subnet.id }
}

output "subnet_address_prefixes" {
  description = "Map of subnet names to their address prefixes"
  value       = { for subnet_key, subnet in azurerm_subnet.subnet : subnet_key => subnet.address_prefixes[0] }
}

output "nsg_ids" {
  description = "Map of subnet names to their network security group IDs"
  value       = { for nsg_key, nsg in azurerm_network_security_group.nsg : nsg_key => nsg.id }
}