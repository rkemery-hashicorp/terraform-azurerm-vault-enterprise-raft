resource "azurerm_resource_group" "vault" {
  name     = "${var.environment}-${random_id.rg.hex}-rg"       
  location = var.location

  tags = {
    environment = "${var.environment}-${random_id.env.hex}-env"
  }
}
