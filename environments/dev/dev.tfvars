environment        = "dev"
location           = "eastus"
project_name       = "OpellaChallenge"
vnet_address_space = ["10.1.0.0/16"]
admin_username     = "adminuser"
admin_ip_address   = "123.123.123.123/32"  # Replace with your real IP address

subnets = [
  {
    name           = "snet-web-dev"
    address_prefix = "10.1.1.0/24"
    service_endpoints = ["Microsoft.Storage"]
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
        source_address_prefix   = "123.123.123.123/32"  # IP del administrador
      }
    }
  },
  {
    name           = "snet-app-dev"
    address_prefix = "10.1.2.0/24"
    service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
    create_nsg     = true
    nsg_rules = {
      app = {
        priority                = 100
        direction               = "Inbound"
        access                  = "Allow"
        protocol                = "Tcp"
        destination_port_range  = "8080"
        source_address_prefix   = "10.1.1.0/24"  # Only from the web subnet
      }
    }
  },
  {
    name           = "snet-db-dev"
    address_prefix = "10.1.3.0/24"
    service_endpoints = ["Microsoft.Storage"]
  }
]

# VM Configuration
vm_size             = "Standard_B1s"
vm_disk_type        = "Standard_LRS"
vm_disk_size        = 30

# Storage settings
storage_account_tier             = "Standard"
storage_account_replication_type = "LRS"
