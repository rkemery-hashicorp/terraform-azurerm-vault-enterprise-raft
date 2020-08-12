variable "tenant_id" {
  default = "0e3e2e88-8caf-41ca-b4da-e3b33b6c52ec"
}

variable "key_name" {
  description = "Azure Key Vault key name"
  default     = "rk-vault-key"
}

variable "location" {
  description = "Azure location where the Key Vault resource to be created"
  default     = "eastus"
}

variable "environment" {
  default = "rk-vault"
}

variable "vnet_prefixes" {
  type    = list
  default = ["10.0.0.0/16"]
}

variable "vault_subnet_prefixes" {
  type    = list
  default = ["10.0.2.0/24"]
}

variable "appgw_subnet_prefixes" {
  type    = list
  default = ["10.0.1.0/24"]
}

variable "source_prefix" {
  default = "184.17.68.160/32"
}

variable "instance_count" {
  type    = number
  default = 3
}

variable "byte_length" {
  type    = number
  default = 4
}

variable "vm_username" {
  default = "vault"
}

variable "vm_size" {
  default = "Standard_B2"
}

variable "vm_disk_type" {
  default = "Premium_LRS"
}

variable "vm_disk_size" {
  default = "32"
}

variable "vm_sku" {
  default = "18.04-LTS"
}

variable "vault_download_url" {
  default = "https://releases.hashicorp.com/vault/1.5.0+ent/vault_1.5.0+ent_windows_amd64.zip"
}

variable "backend_http_port" {
  default = "8200"
}

variable "ip_addresses" {
  default = [
    "10.0.2.11",
    "10.0.2.12",
    "10.0.2.13",
  ]
}

