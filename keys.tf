resource "tls_private_key" "vault" {
  algorithm = "RSA"
  rsa_bits = 4096
}
