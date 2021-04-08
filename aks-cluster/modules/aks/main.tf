data "azuread_user" "aks_rbac_user" {
  user_principal_name = "ADD YOUR UPN HERE FROM AZURE AD"
}

resource "azuread_group" "aks_admins" {
  display_name = "aks_admins"
  members = [
    data.azuread_user.aks_rbac_user.object_id
  ]
}

resource "tls_private_key" "ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_kubernetes_cluster" "todo" {
  name                = var.cluster_name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  dns_prefix          = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  sku_tier            = "Free"
  tags                = var.tags

  linux_profile {
    admin_username = var.admin_username

    ssh_key {
      key_data = trimspace(tls_private_key.ssh-key.public_key_openssh)
    }
  }

  network_profile {
    network_plugin     = "azure"
    dns_service_ip     = "10.0.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
    service_cidr       = "10.0.0.0/16"
    load_balancer_sku  = "Standard"
  }

  default_node_pool {
    name                 = substr(var.default_node_pool.name, 0, 12)
    orchestrator_version = var.kubernetes_version
    node_count           = var.default_node_pool.node_count
    vm_size              = var.default_node_pool.vm_size
    type                 = var.default_node_pool.type
    availability_zones   = var.default_node_pool.zones
    max_pods             = var.default_node_pool.max_pods
    os_disk_size_gb      = var.default_node_pool.os_disk_size_gb
    vnet_subnet_id       = var.subnet_id
    enable_auto_scaling  = var.default_node_pool.cluster_auto_scaling
    min_count            = var.default_node_pool.cluster_auto_scaling_min_count
    max_count            = var.default_node_pool.cluster_auto_scaling_max_count
    tags                 = var.tags
  }

  auto_scaler_profile {
    scale_down_utilization_threshold = 0.3
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control {
    enabled = true

    azure_active_directory {
      managed                = true
      admin_group_object_ids = [azuread_group.aks_admins.id]
    }
  }

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count
    ]
  }
}


# This role enables cluster autoscaling
resource "azurerm_role_assignment" "aks_network_role" {
  principal_id         = azurerm_kubernetes_cluster.todo.identity[0].principal_id
  role_definition_name = "Network Contributor"
  scope                = var.vnet_id
}
