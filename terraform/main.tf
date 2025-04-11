provider "azurerm" {
  features {}
}

locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
    DeployedOn  = formatdate("YYYY-MM-DD", timestamp())
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.environment}-${var.location}"
  location = var.location
  tags     = local.common_tags
}

module "vnet" {
  source              = "./modules/vnet"
  vnet_name           = "vnet-${var.environment}-${var.location}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = var.vnet_address_space
  subnets             = var.subnets
  tags                = local.common_tags
}

module "compute" {
  source              = "./modules/compute"
  vm_name             = "vm-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = module.vnet.subnet_ids[var.subnets[0].name]  # Usar la primera subred para la VM
  admin_username      = var.admin_username
  admin_ssh_public_key = var.admin_ssh_public_key
  vm_size             = var.vm_size
  os_disk_type        = var.vm_disk_type
  os_disk_size        = var.vm_disk_size
  tags                = local.common_tags
}

module "storage" {
  source                   = "./modules/storage"
  environment              = var.environment
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  tier                     = var.storage_account_tier
  replication_type         = var.storage_account_replication_type
  subnet_ids               = [for subnet in var.subnets : module.vnet.subnet_ids[subnet.name] if contains(subnet.service_endpoints, "Microsoft.Storage")]
  admin_ip_address         = var.admin_ip_address
  tags                     = local.common_tags
}

# Recurso condicional para Key Vault (solo en producción)
resource "azurerm_key_vault" "kv" {
  count                       = var.create_key_vault ? 1 : 0
  name                        = "kv-${var.environment}-${random_string.kv_suffix[0].result}"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 90
  purge_protection_enabled    = true
  sku_name                    = "standard"

  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    virtual_network_subnet_ids = [for subnet in var.subnets : module.vnet.subnet_ids[subnet.name] if contains(subnet.service_endpoints, "Microsoft.KeyVault")]
    ip_rules                   = [var.admin_ip_address]
  }

  tags = local.common_tags
}

resource "random_string" "kv_suffix" {
  count   = var.create_key_vault ? 1 : 0
  length  = 6
  special = false
  upper   = false
}

data "azurerm_client_config" "current" {}