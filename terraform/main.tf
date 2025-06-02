/****************************************************
*                       RG                          *
*****************************************************/
resource "azurerm_resource_group" "main" {
  name     = "ScSc-CIO_ECT_mcp-servers-rg"
  location = var.default_location
}

module "br-mcp-server" {
  source = "./modules/mcp-server"

  default_location    = var.default_location
  resource_group_name = azurerm_resource_group.main.name
  app_name            = "br-mcp-server-app"
  
  # Access restrictions
  frontend_app_ip      = var.frontend_app_ip
  developer_ip_addresses = var.developer_ip_addresses
  allowed_origins      = var.allowed_origins
  
  # ACR credentials
  acr_admin_username = azurerm_container_registry.acr.admin_username
  acr_admin_password = azurerm_container_registry.acr.admin_password
  acr_login_server   = azurerm_container_registry.acr.login_server
  
  # Application settings
  app_settings = {
    ENV = "production"
    PORT = "8000"
    WEBSITES_PORT = "8000"
    WEBSITE_HTTPLOGGING_RETENTION_DAYS = "30"
  }
  
  # Source code repository
  repo_url = "https://github.com/dto-btn/br-mcp-server"
  branch   = "main"

}