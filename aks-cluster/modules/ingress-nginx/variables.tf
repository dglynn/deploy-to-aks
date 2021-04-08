variable "public_ip" {
  type        = string
  description = "The public ip of the AKS cluster"
}

variable "chart_version" {
  type        = string
  default     = "3.19"
  description = "The version of the ingress-nginx chart"
}
