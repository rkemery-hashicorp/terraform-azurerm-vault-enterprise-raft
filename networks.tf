resource "azurerm_virtual_network" "vault" {
  name                = "${var.environment}-${random_id.vnet.hex}-vnet"
  address_space       = var.vnet_prefixes
  location            = var.location
  resource_group_name = azurerm_resource_group.vault.name

  tags = {
    environment = "${var.environment}-${random_id.env.hex}-env"
  }
}

resource "azurerm_subnet" "vault" {
  name                 = "${var.environment}-${random_id.vault_subnet.hex}-subnet"
  resource_group_name  = azurerm_resource_group.vault.name
  virtual_network_name = azurerm_virtual_network.vault.name
  address_prefixes     = var.vault_subnet_prefixes
}

resource "azurerm_subnet" "appgateway" {
  name                 = "${var.environment}-${random_id.appgw_subnet.hex}-subnet"
  resource_group_name  = azurerm_resource_group.vault.name
  virtual_network_name = azurerm_virtual_network.vault.name
  address_prefixes     = var.appgw_subnet_prefixes
}
