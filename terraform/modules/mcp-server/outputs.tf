output "web_app_name" {
  value       = azurerm_linux_web_app.server.name
  description = "The name of the web app"
}

output "outbound_ip_addresses" {
  value       = azurerm_linux_web_app.server.outbound_ip_addresses
  description = "The outbound IP addresses of the web app"
}

output "possible_outbound_ip_addresses_list" {
  value       = azurerm_linux_web_app.server.possible_outbound_ip_address_list
  description = "The possible outbound IP addresses of the web app"
}

output "web_app_id" {
  value       = azurerm_linux_web_app.server.id
  description = "The ID of the web app"
}
