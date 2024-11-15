resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "NTI_key" {
  key_name   = "NTI"
  public_key = tls_private_key.key.public_key_openssh
  
}

# Output the private key content to download locally
output "NTI_private_key" {
  value     = tls_private_key.key.private_key_pem
  sensitive = true
}