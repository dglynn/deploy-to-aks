variable "name_prefix" {
  type        = string
  description = "This string will be prepended to the names of the resources on azure"
}

variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "The resource group in which the resources should be placed"
}

variable "tags" {
  type        = map(string)
  description = "These free-form tags will be applied to azure resources"
}
