output "acr_login_server" {
  value       = azurerm_container_registry.acr.login_server
  description = "The login server URL for the Azure Container Registry"
}

output "container_group_fqdn" {
  value       = module.mcp.container_group_fqdn
  description = "The FQDN of the container group"
}

output "container_group_ip_address" {
  value       = module.mcp.container_group_ip_address
  description = "The IP address of the container group"
}
