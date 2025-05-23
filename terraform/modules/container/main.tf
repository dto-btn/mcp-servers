resource "azurerm_container_group" "mcp" {
  name                = var.container_group_name
  location            = var.default_location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"

  dynamic "container" {
    for_each = var.containers
    content {
      name   = container.value.name
      image  = container.value.image
      cpu    = container.value.cpu
      memory = container.value.memory
      
      environment_variables = container.value.env_vars != null ? container.value.env_vars : {}

      dynamic "ports" {
        for_each = container.value.ports != null ? container.value.ports : []
        content {
          port = ports.value
        }
      }
    }
  }

  image_registry_credential {
    username = var.acr_admin_username
    password = var.acr_admin_password
    server   = var.acr_login_server
  }

  ip_address_type = "Public"
  dns_name_label  = var.container_group_name
}