variable "prefix" {
  default = "guardians"
}

variable "region" {
  default = "us-east-1"
}

variable "ssh_public_key_file" {
  default = "../../../keys/id_ed25519.pub"
}

variable "external_ip_allocation" {
  default = "eipalloc-004791e4677f75c6e"
}
