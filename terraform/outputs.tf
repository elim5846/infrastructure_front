output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "public_ip_address front" {
  value = azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address
}

output "public_ip_address back" {
  value = azurerm_linux_virtual_machine.my_terraform_back.public_ip_address
}
