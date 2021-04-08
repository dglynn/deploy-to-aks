output "kubenet_name" {
  value = azurerm_subnet.aks_subnet.name
}

output "kubenet_id" {
  value = azurerm_subnet.aks_subnet.id
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}
