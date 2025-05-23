output "container_group_fqdn" {
  value       = azurerm_container_group.mcp.fqdn
  description = "The FQDN of the container group"
}

output "container_group_ip_address" {
  value       = azurerm_container_group.mcp.ip_address
  description = "The IP address of the container group"
}
