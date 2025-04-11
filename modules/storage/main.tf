resource "random_string" "storage_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_storage_account" "storage" {
  name                     = "st${var.environment}${random_string.storage_suffix.result}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.tier
  account_replication_type = var.replication_type
  min_tls_version          = "TLS1_2"
  
  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = var.subnet_ids
    ip_rules                   = [var.admin_ip_address]
    bypass                     = ["AzureServices"]
  }
  
  tags = var.tags
}

resource "azurerm_storage_container" "container" {
  name                  = "data"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}