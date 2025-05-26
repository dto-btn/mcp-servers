output "acr_login_server" {
  value       = azurerm_container_registry.acr.login_server
  description = "The login server URL for the Azure Container Registry"
}

output "web_app_url" {
  value       = "https://${module.mcp_server.default_site_hostname}"
  description = "The URL of the web app"
}

output "web_app_name" {
  value       = module.mcp_server.web_app_name
  description = "The name of the web app"
}

output "web_app_outbound_ip_addresses" {
  value       = module.mcp_server.outbound_ip_addresses
  description = "The outbound IP addresses of the web app"
}
