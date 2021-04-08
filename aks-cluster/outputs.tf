output "aks_config" {
  value     = "az aks get-credentials --subscription ${var.subscription_id} --resource-group ${azurerm_resource_group.aks_rg.name} --name ${module.aks.name} --overwrite-existing"
  sensitive = false
  description = "The command to run to access the AKS cluster from your local machine using the AZ Cli"
}

output "aks_public_ip" {
  value       = module.public_ip.aks_ip_address
  sensitive   = false
  description = "The AKS cluster public ip"
}
