output "public_ips" {
  value = join(",", azurerm_linux_virtual_machine.vault.*.public_ip_address)
}

output "private_ips" {
  value = join(",", azurerm_linux_virtual_machine.vault.*.private_ip_address)
}

output "key_vault_name" {
  value = "${azurerm_key_vault.vault.name}"
}
