output "web_app_name" {
  value       = azurerm_app_service.mcp_app.name
  description = "The name of the web app"
}

output "default_site_hostname" {
  value       = azurerm_app_service.mcp_app.default_site_hostname
  description = "The default hostname of the web app"
}

output "outbound_ip_addresses" {
  value       = azurerm_app_service.mcp_app.outbound_ip_addresses
  description = "The outbound IP addresses of the web app"
}

output "possible_outbound_ip_addresses" {
  value       = azurerm_app_service.mcp_app.possible_outbound_ip_addresses
  description = "The possible outbound IP addresses of the web app"
}

output "identity_principal_id" {
  value       = azurerm_app_service.mcp_app.identity[0].principal_id
  description = "The Principal ID of the System Assigned Identity"
}
