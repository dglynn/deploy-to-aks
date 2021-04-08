resource "azurerm_public_ip" "aks" {
  name                = "${var.name_prefix}-aks-ip"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}
