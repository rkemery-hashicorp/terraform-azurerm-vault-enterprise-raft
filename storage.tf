resource "azurerm_storage_account" "vault" {
  name                     = "${var.environment}-${random_id.sa.hex}-sa"
  resource_group_name      = azurerm_resource_group.vault.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "${var.environment}-${random_id.env.hex}-env"
  }
}
