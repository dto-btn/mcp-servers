resource "azurerm_linux_web_app" "server" {
  name                = "${var.name}"
  resource_group_name = var.rg_name
  location            = var.default_location
  service_plan_id     = var.app_plan_id

  virtual_network_subnet_id = var.subnet_id

  client_affinity_enabled = true
  https_only = true

  site_config {
    ftps_state = "FtpsOnly"

    application_stack {
      python_version = "3.12"
    }
    use_32_bit_worker = false

    app_command_line = "python server.py"

    dynamic "ip_restriction" {
      for_each = var.allowed_ips
      content {
        ip_address = "${ip_restriction.value}/32"
        action     = "Allow"
        priority   = 100 + ip_restriction.key
        name       = "AllowIP${ip_restriction.key}"
      }
    }

    ip_restriction {
      ip_address = "0.0.0.0/0"
      action     = "Deny"
      priority   = 1000
      name       = "DenyAll"
    }
  }

  app_settings = merge({
    PORT = "8000"
    SCM_DO_BUILD_DURING_DEPLOYMENT = "true"
    TRUSTED_HOST = "${var.name}.azurewebsites.net"
  }, var.app_settings)
}

# IP restrictions for the web app
# resource "azurerm_app_service_ip_restriction" "frontend_app" {
#   name                      = "AllowFrontendApp"
#   app_service_id            = azurerm_app_service.mcp_app.id
#   ip_address                = "${var.frontend_app_ip}/32"
#   priority                  = 100
#   action                    = "Allow"
# }

# # Create IP restrictions for each developer IP
# resource "azurerm_app_service_ip_restriction" "developer_ips" {
#   count                     = length(var.developer_ip_addresses)
#   name                      = "AllowDeveloper-${count.index}"
#   app_service_id            = azurerm_app_service.mcp_app.id
#   ip_address                = "${var.developer_ip_addresses[count.index]}/32"
#   priority                  = 200 + count.index
#   action                    = "Allow"
# }