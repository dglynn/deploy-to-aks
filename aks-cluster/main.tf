provider "azurerm" {
  subscription_id = var.subscription_id

  features {}
  #use_msi = true
}

provider "azuread" {
  #use_msi   = true
  tenant_id = var.tenant_id
}

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

provider "kubernetes" {
  load_config_file       = false
  host                   = module.aks.host
  username               = module.aks.cluster_username
  password               = module.aks.cluster_password
  client_certificate     = base64decode(module.aks.client_certificate)
  client_key             = base64decode(module.aks.client_key)
  cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
}

provider "helm" {
  debug = true

  kubernetes {
    load_config_file       = false
    host                   = module.aks.host
    username               = module.aks.cluster_username
    password               = module.aks.cluster_password
    client_certificate     = base64decode(module.aks.client_certificate)
    client_key             = base64decode(module.aks.client_key)
    cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
  }
}

resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group.name
  location = var.resource_group.location
  tags     = var.tags
}

module "network" {
  source = "./modules/network"

  resource_group = var.resource_group
  network_name   = var.network_name
  cluster_name   = var.cluster_name
  tags           = var.tags
  depends_on     = [azurerm_resource_group.aks_rg]
}

module "aks" {
  source = "./modules/aks"

  resource_group     = var.resource_group
  cluster_name       = var.cluster_name
  admin_username     = var.admin_username
  vnet_id            = module.network.vnet_id
  subnet_id          = module.network.kubenet_id
  kubernetes_version = var.aks_version
  default_node_pool  = var.default_node_pool
  tags               = var.tags
}

module "public_ip" {
  source = "./modules/public_ip"

  name_prefix    = var.cluster_name
  resource_group = module.aks.resource_group
  tags           = var.tags
}

module "ingress" {
  source = "./modules/ingress-nginx"

  public_ip = module.public_ip.aks_ip_address
}
