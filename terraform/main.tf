/****************************************************
*                       RG                          *
*****************************************************/
resource "azurerm_resource_group" "main" {
  name     = "ScSc-CIO_ECT_mcp-servers-rg"
  location = var.default_location
}

module "mcp" {
  source = "./modules/container"

  default_location     = var.default_location
  resource_group_name = azurerm_resource_group.main.name
  container_group_name = "mcp-containergroup"
  
  # ACR credentials
  acr_admin_username = azurerm_container_registry.acr.admin_username
  acr_admin_password = azurerm_container_registry.acr.admin_password
  acr_login_server   = azurerm_container_registry.acr.login_server
  
  # Dependencies to ensure docker build is completed first
  depends_on = [null_resource.docker_build_push]
  
  containers = [
    {
      name   = "mcp-br"
      image  = "${azurerm_container_registry.acr.login_server}/mcp-br:latest"
      cpu    = 1
      memory = 1.5
      env_vars = {
        ENV = "development"
      }
      ports = [8000]
    },
  ]
}