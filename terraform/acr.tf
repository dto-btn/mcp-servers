resource "azurerm_container_registry" "acr" {
  name                = "mcpserversregistry"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.default_location
  sku                 = "Basic"
  admin_enabled       = true
}

# This resource will build and push the Docker image to ACR
resource "null_resource" "docker_build_push" {
  triggers = {
    # This will force the resource to be re-created when the Dockerfile or server code changes
    dockerfile_hash = filemd5("${path.module}/../../mcp-server-demo/Dockerfile")
    server_py_hash  = filemd5("${path.module}/../../mcp-server-demo/server.py")
    pyproject_hash  = filemd5("${path.module}/../../mcp-server-demo/pyproject.toml")
    # You can add more files to watch here
  }

  # Dependencies
  depends_on = [
    azurerm_container_registry.acr
  ]

  provisioner "local-exec" {
    working_dir = "${path.module}/../../mcp-server-demo"
    command = <<-EOT
      # Login to Azure
      az acr login --name ${azurerm_container_registry.acr.name}
      
      # Build and tag the Docker image
      docker build -t ${azurerm_container_registry.acr.login_server}/mcp-br:latest .
      
      # Push the image to ACR
      docker push ${azurerm_container_registry.acr.login_server}/mcp-br:latest
    EOT
  }
}
