output "client_key" {
  value = azurerm_kubernetes_cluster.todo.kube_admin_config.0.client_key
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.todo.kube_admin_config.0.client_certificate
}

output "cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.todo.kube_admin_config.0.cluster_ca_certificate
}

output "cluster_username" {
  value = azurerm_kubernetes_cluster.todo.kube_admin_config.0.username
}

output "cluster_password" {
  value = azurerm_kubernetes_cluster.todo.kube_admin_config.0.password
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.todo.kube_config_raw
}

output "host" {
  value = azurerm_kubernetes_cluster.todo.kube_config.0.host
}

output "name" {
  value = azurerm_kubernetes_cluster.todo.name
}

output "resource_group" {
  value = {
    location = var.resource_group.location
    name     = azurerm_kubernetes_cluster.todo.node_resource_group
  }
}

output "cluster_identity" {
  value = azurerm_kubernetes_cluster.todo.identity[0].principal_id
}

output "kubelet_identity" {
  value = {
    object_id = azurerm_kubernetes_cluster.todo.kubelet_identity[0].object_id
    client_id = azurerm_kubernetes_cluster.todo.kubelet_identity[0].client_id
  }
}
