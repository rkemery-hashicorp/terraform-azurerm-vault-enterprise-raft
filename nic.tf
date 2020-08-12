resource "azurerm_network_interface" "vault" {
  count                     = var.instance_count
  name                      = "${var.environment}-${random_id.nic.hex}-${count.index}-nic"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.vault.name

  ip_configuration {
    name                          = "${var.environment}-${random_id.private_ip.hex}-${count.index}-ip"
    subnet_id                     = azurerm_subnet.vault.id
    private_ip_address_allocation = "Static"
    private_ip_address            = element(var.ip_addresses, count.index)
    # public_ip_address_id          = azurerm_public_ip.vault[count.index].id
  }

  tags = {
    environment = "${var.environment}-${random_id.env.hex}-env"
  }
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "vault" {
  count                   = length(azurerm_network_interface.vault)
  network_interface_id    = element(azurerm_network_interface.vault.*.id, count.index)
  ip_configuration_name   = "${var.environment}-${random_id.private_ip.hex}-${count.index}-ip"
  backend_address_pool_id = azurerm_application_gateway.appgateway.backend_address_pool[0].id
}
