output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

/*
output "public_ip_address_front" {
  value = [for vm in azurerm_linux_virtual_machine.my_terraform_vm : vm.public_ip_address]
}

output "public_ip_address_back" {
  value = azurerm_linux_virtual_machine.my_terraform_back.public_ip_address
}
*/

output "public_ip_address_db" {
  value = azurerm_linux_virtual_machine.my_terraform_db.public_ip_address
}