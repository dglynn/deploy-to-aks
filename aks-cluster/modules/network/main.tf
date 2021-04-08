resource "azurerm_virtual_network" "vnet" {
  name                = "${var.network_name}-vnet"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  address_space       = ["10.0.0.0/8"]
  tags                = var.tags
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "${var.network_name}-subnet"
  address_prefixes     = ["10.240.0.0/16"]
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  service_endpoints    = ["Microsoft.AzureActiveDirectory", "Microsoft.KeyVault", "Microsoft.Sql", "Microsoft.Storage", "Microsoft.ContainerRegistry"]
}


resource "azurerm_network_security_group" "aks_nsg" {
  name                = "${var.cluster_name}-aks-nsg"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  tags                = var.tags

  security_rule {
    name                       = "HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
