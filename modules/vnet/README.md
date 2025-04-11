# Azure Virtual Network (VNET) Module

This Terraform module creates a Virtual Network (VNET) in Azure with flexible configurations, including subnets, Network Security Groups (NSGs), and security rules.

## Features

- Creates a VNET with configurable address spaces  
- Supports creation of multiple subnets  
- Supports service endpoints  
- Optional creation of per-subnet Network Security Groups (NSGs)  
- Configurable NSG rules per subnet  
- Subnet delegation support  
- Comprehensive tagging system  

## Usage

```hcl
module "vnet" {
  source              = "../modules/vnet"
  vnet_name           = "my-vnet"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/16"]
  
  subnets = [
    {
      name           = "subnet1"
      address_prefix = "10.0.1.0/24"
      service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
      create_nsg     = true
      nsg_rules = {
        ssh = {
          priority               = 100
          direction              = "Inbound"
          access                 = "Allow"
          protocol               = "Tcp"
          destination_port_range = "22"
        }
      }
    },
    {
      name           = "subnet2"
      address_prefix = "10.0.2.0/24"
    }
  ]
  
  tags = {
    Environment = "Development"
    Project     = "MyProject"
  }
}