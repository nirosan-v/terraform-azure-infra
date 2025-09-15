# Step 7: Outputs
# VM Name
output "vm_name" {
  value = azurerm_linux_virtual_machine.vm.name
}

# Public IP of VM
output "vm_public_ip" {
  value = azurerm_public_ip.public_ip.ip_address
}
