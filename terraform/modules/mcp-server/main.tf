
# App Service Plan
resource "azurerm_app_service_plan" "mcp_plan" {
  name                = "${var.app_name}-plan"
  location            = var.default_location
  resource_group_name = var.resource_group_name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

# Web App
resource "azurerm_app_service" "mcp_app" {
  name                = var.app_name
  location            = var.default_location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.mcp_plan.id
  https_only          = true

  site_config {
    linux_fx_version = "PYTHON|3.10"
    always_on        = true
    
    cors {
      allowed_origins = var.allowed_origins
      support_credentials = true
    }
  }

  app_settings = merge({
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "true"
    "SCM_DO_BUILD_DURING_DEPLOYMENT"      = "true"
    "DOCKER_REGISTRY_SERVER_URL"          = "https://${var.acr_login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME"     = var.acr_admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD"     = var.acr_admin_password
    "PYTHON_ENV"                          = "production"
  }, var.app_settings)

  # Configure deployment from ACR
  identity {
    type = "SystemAssigned"
  }

  # Configure connection to source repository if provided
  dynamic "source_control" {
    for_each = var.repo_url != null ? [1] : []
    content {
      repo_url           = var.repo_url
      branch             = var.branch
      manual_integration = true
    }
  }
}

# IP restrictions for the web app
resource "azurerm_app_service_ip_restriction" "frontend_app" {
  name                      = "AllowFrontendApp"
  app_service_id            = azurerm_app_service.mcp_app.id
  ip_address                = "${var.frontend_app_ip}/32"
  priority                  = 100
  action                    = "Allow"
}

# Create IP restrictions for each developer IP
resource "azurerm_app_service_ip_restriction" "developer_ips" {
  count                     = length(var.developer_ip_addresses)
  name                      = "AllowDeveloper-${count.index}"
  app_service_id            = azurerm_app_service.mcp_app.id
  ip_address                = "${var.developer_ip_addresses[count.index]}/32"
  priority                  = 200 + count.index
  action                    = "Allow"
}

# Network security with VNet Integration if requested
resource "azurerm_virtual_network" "mcp_vnet" {
  count               = var.enable_vnet_integration ? 1 : 0
  name                = "${var.app_name}-vnet"
  location            = var.default_location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "webapp_subnet" {
  count                = var.enable_vnet_integration ? 1 : 0
  name                 = "webapp-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.mcp_vnet[0].name
  address_prefixes     = ["10.0.1.0/24"]
  
  delegation {
    name = "delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnet_integration" {
  count          = var.enable_vnet_integration ? 1 : 0
  app_service_id = azurerm_app_service.mcp_app.id
  subnet_id      = azurerm_subnet.webapp_subnet[0].id
}
