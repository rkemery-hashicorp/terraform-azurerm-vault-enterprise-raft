data "template_file" "setup" {
  template = "${file("${path.module}/templates/setup.tpl")}"

    vars = {
    # resource_group_name = azurerm_resource_group.vault.name
    # vm_name             = element(azurerm_linux_virtual_machine.vault.*.name, count.index)
      vault_download_url  = "${var.vault_download_url}"
    # tenant_id           = "${var.tenant_id}"
    # subscription_id     = "${var.subscription_id}"
    # client_id           = "${var.client_id}"
    # client_secret       = "${var.client_secret}"
    # vault_name          = azurerm_key_vault.vault.name
    # key_name            = azurerm_key_vault_key.vault.name
    }
}

resource "azurerm_linux_virtual_machine" "vault" {
  name                  = "${var.environment}-${random_id.vm.hex}-${count.index}-vm"
  count                 = var.instance_count
  custom_data           = base64encode("${data.template_file.setup.rendered}")
  location              = var.location
  resource_group_name   = azurerm_resource_group.vault.name
  size                  = var.vm_size
  admin_username        = var.vm_username
  network_interface_ids = [
    element(azurerm_network_interface.vault.*.id, count.index)
  ]

  os_disk {
    caching               = "ReadWrite"
    storage_account_type  = var.vm_disk_type
    disk_size_gb          = var.vm_disk_size
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = var.vm_sku
    version   = "latest"
  }

  admin_ssh_key {
    username   = var.vm_username
    public_key = tls_private_key.vault.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.vault.primary_blob_endpoint
  }

  tags = {
    environment = "${var.environment}-${random_id.env.hex}-env"
  }

  depends_on = [data.template_file.setup]
}
