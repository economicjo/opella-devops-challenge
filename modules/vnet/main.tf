resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  tags                = var.tags
}

resource "azurerm_subnet" "subnet" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }

  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value.address_prefix]
  service_endpoints    = lookup(each.value, "service_endpoints", [])

  dynamic "delegation" {
    for_each = lookup(each.value, "delegation", {}) != {} ? [1] : []
    
    content {
      name = each.value.delegation.name
      
      service_delegation {
        name    = each.value.delegation.service_delegation_name
        actions = lookup(each.value.delegation, "service_delegation_actions", [])
      }
    }
  }
}

resource "azurerm_network_security_group" "nsg" {
  for_each = { for subnet in var.subnets : subnet.name => subnet if lookup(subnet, "create_nsg", false) }

  name                = "${each.value.name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  for_each = { for subnet in var.subnets : subnet.name => subnet if lookup(subnet, "create_nsg", false) }

  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}

resource "azurerm_network_security_rule" "nsg_rules" {
  for_each = {
    for rule in local.nsg_rules : "${rule.subnet_name}-${rule.name}" => rule
  }

  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = lookup(each.value, "source_port_range", "*")
  destination_port_range      = lookup(each.value, "destination_port_range", "*")
  source_address_prefix       = lookup(each.value, "source_address_prefix", "*")
  destination_address_prefix  = lookup(each.value, "destination_address_prefix", "*")
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg[each.value.subnet_name].name
}

locals {
  nsg_rules = flatten([
    for subnet_key, subnet in { for subnet in var.subnets : subnet.name => subnet if lookup(subnet, "create_nsg", false) } : [
      for rule_key, rule in lookup(subnet, "nsg_rules", {}) : {
        subnet_name                 = subnet_key
        name                        = rule_key
        priority                    = rule.priority
        direction                   = rule.direction
        access                      = rule.access
        protocol                    = rule.protocol
        source_port_range           = lookup(rule, "source_port_range", "*")
        destination_port_range      = lookup(rule, "destination_port_range", "*")
        source_address_prefix       = lookup(rule, "source_address_prefix", "*")
        destination_address_prefix  = lookup(rule, "destination_address_prefix", "*")
      }
    ]
  ])
}