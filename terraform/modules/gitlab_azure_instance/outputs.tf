output "machine_names" {
  value = azurerm_linux_virtual_machine.gitlab[*].name
}

output "internal_addresses" {
  value = {
    for _, v in azurerm_linux_virtual_machine.gitlab[*] : "${v.name}.internal.cloudapp.net" => v.private_ip_address
  }
}

output "external_addresses" {
  value = var.setup_external_ip ? azurerm_linux_virtual_machine.gitlab[*].public_ip_address : []
}

output "virtual_machine_ids" {
  value = azurerm_linux_virtual_machine.gitlab[*].virtual_machine_id
}
