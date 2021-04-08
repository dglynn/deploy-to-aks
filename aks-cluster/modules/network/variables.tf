variable "network_name" {
  type        = string
  description = "The vnet AKS name"
}

variable "aks_subnet_name" {
  type        = string
  default     = "todo-subnet"
  description = "THe AKS subnet name"
}

variable "cluster_name" {
  type        = string
  description = "The name for the AKS cluster"
}

variable "tags" {
  description = "These free-form tags will be applied to azure resources"
  type        = map(string)
}

variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
}
