variable "tenant_id" {
  type        = string
  default     = "ADD YOUR TENANT ID HERE"
  description = "The tenant id of your Azure account"
}

variable "subscription_id" {
  type        = string
  default     = "ADD YOUR SUBSCRIPTION ID HERE"
  description = "A subscription id in your Azure tenant"
}

variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  default = {
    name     = "todo"
    location = "northeurope"
  }
  description = "The resource group name and location for all the resources that will be created"
}

variable "aks_version" {
  type        = string
  default     = "1.19.7"
  description = "The version of AKS to deploy"
}

variable "admin_username" {
  type        = string
  default     = "ubuntu"
  description = "The admin username for the AKS cluster"
}

variable "cluster_name" {
  type        = string
  default     = "todo"
  description = "The name for the AKS cluster"
}


variable "default_node_pool" {
  type = object({
    name                           = string
    node_count                     = number
    vm_size                        = string
    type                           = string
    zones                          = list(string)
    max_pods                       = number
    os_disk_size_gb                = number
    cluster_auto_scaling           = bool
    cluster_auto_scaling_min_count = number
    cluster_auto_scaling_max_count = number

  })
  default = {
    name                           = "default"
    node_count                     = 3
    vm_size                        = "Standard_B2s"
    type                           = "VirtualMachineScaleSets"
    max_pods                       = 30
    os_disk_size_gb                = 30
    zones                          = ["1", "2", "3"]
    cluster_auto_scaling           = true
    cluster_auto_scaling_min_count = 3
    cluster_auto_scaling_max_count = 5
  }
  description = "The object to configure the default node pool with number of worker nodes, worker node VM size, Availability Zones and autoscaling node counts."
}

variable "network_name" {
  type        = string
  default     = "todo"
  description = "The AKS vnet name"
}


variable "tags" {
  type = map(string)

  default = {
    AppGroup = "Kubernetes Cluster",
    Type     = "Dev"
  }
  description = "These free-form tags will be applied to Azure resources"
}
