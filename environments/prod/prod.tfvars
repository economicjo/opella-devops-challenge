environment        = "prod"
location           = "westus2"
project_name       = "OpellaChallenge"
vnet_address_space = ["10.2.0.0/16"]
admin_username     = "adminuser"
admin_ip_address   = "123.123.123.123/32"  # Replace with your real IP address


subnets = [
  {
    name           = "snet-web-prod"
    address_prefix = "10.2.1.0/24"
    service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
    create_nsg     = true
    nsg_rules = {
      http = {
        priority                = 100
        direction               = "Inbound"
        access                  = "Allow"
        protocol                = "Tcp"
        destination_port_range  = "80"
      }
      https = {
        priority                = 110
        direction               = "Inbound"
        access                  = "Allow"
        protocol                = "Tcp"
        destination_port_range  = "443"
      }
      ssh = {
        priority                = 120
        direction               = "Inbound"
        access                  = "Allow"
        protocol                = "Tcp"
        destination_port_range  = "22"
        source_address_prefix   = "123.123.123.123/32"  # Administrator IP
      }
    }
  },
  {
    name           = "snet-app-prod"
    address_prefix = "10.2.2.0/24"
    service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
    create_nsg     = true
    nsg_rules = {
      app = {
        priority                = 100
        direction               = "Inbound"
        access                  = "Allow"
        protocol                = "Tcp"
        destination_port_range  = "8080"
        source_address_prefix   = "10.2.1.0/24"  # Only from the web subnet
      }
    }
  },
  {
    name           = "snet-db-prod"
    address_prefix = "10.2.3.0/24"
    service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.Sql"]
    delegation = {
      name                       = "delegation"
      service_delegation_name    = "Microsoft.Sql/managedInstances"
      service_delegation_actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
]

# VM Configuration - More Robust for Production
vm_size             = "Standard_B2s"
vm_disk_type        = "Premium_LRS"
vm_disk_size        = 64

# Storage configuration - with geo-replication for production
storage_account_tier             = "Standard"
storage_account_replication_type = "GRS"

# Enable Key Vault
create_key_vault    = true
