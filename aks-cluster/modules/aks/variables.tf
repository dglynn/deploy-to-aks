variable "subnet_id" {
  type = string
}

variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
}

variable "cluster_name" {
  type        = string
  description = "The AKS cluster name"
}

variable "admin_username" {
  type        = string
  description = "The admin username for the AKS cluster"
}

variable "default_node_pool" {
  type = object({
    name                           = string
    node_count                     = number
    vm_size                        = string
    zones                          = list(string)
    type                           = string
    max_pods                       = number
    os_disk_size_gb                = number
    cluster_auto_scaling           = bool
    cluster_auto_scaling_min_count = number
    cluster_auto_scaling_max_count = number
  })
  description = "The object to configure the default node pool with number of worker nodes, worker node VM size, Availability Zones and autoscaling node counts."
}

variable "kubernetes_version" {
  type = string
}

variable "vnet_id" {
  type = string
}

variable "tags" {
  type        = map(string)
  description = "These free-form tags will be applied to azure resources"
}
