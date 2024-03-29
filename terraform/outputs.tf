output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "public_ip_address_front" {
  value = azurerm_public_ip.my_terraform_public_ip_front.ip_address
}

output "public_ip_address_back" {
  value = azurerm_public_ip.my_terraform_public_ip_back.ip_address
}

output "public_ip_address_db" {
  value = azurerm_linux_virtual_machine.my_terraform_db.public_ip_address
}

output "public_ip_address_db_rep" {
  value = azurerm_linux_virtual_machine.my_terraform_db_replicate.public_ip_address
}