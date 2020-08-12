resource "random_id" "keyvault" {
  byte_length = var.byte_length
}

resource "random_id" "rg" {
  byte_length = var.byte_length
}

resource "random_id" "env" {
  byte_length = var.byte_length
}

resource "random_id" "key" {
  byte_length = var.byte_length
}

resource "random_id" "vnet" {
  byte_length = var.byte_length
}

resource "random_id" "vault_subnet" {
  byte_length = var.byte_length
}

resource "random_id" "appgw_subnet" {
  byte_length = var.byte_length
}

resource "random_id" "nsg" {
  byte_length = var.byte_length
}

resource "random_id" "nic" {
  byte_length = var.byte_length
}

resource "random_id" "private_ip" {
  byte_length = var.byte_length
}

resource "random_id" "public_ip" {
  byte_length = var.byte_length
}

resource "random_id" "sa" {
  byte_length = var.byte_length
}

resource "random_id" "vm" {
  byte_length = var.byte_length
}

resource "random_id" "cert" {
  byte_length = var.byte_length
}

resource "random_id" "cert2" {
  byte_length = var.byte_length
}
