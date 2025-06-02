/****************************************************
*                       RG                          *
*****************************************************/
resource "azurerm_resource_group" "main" {
  name     = "ScSc-CIO_ECT_mcp-servers-rg"
  location = var.default_location
}

resource "azurerm_service_plan" "mcp_plan" {
  name                = "br-mcp-server-app-plan"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.default_location
  sku_name            = "S1"
  os_type             = "Linux"
}

module "vnet" {
  source = "./modules/vnet"

  default_location = var.default_location
  name     = "br-mcp-server"
  rg_name          = azurerm_resource_group.main.name
}

module "br-mcp-server" {
  source = "./modules/mcp-server"

  default_location    = var.default_location
  rg_name = azurerm_resource_group.main.name
  name            = "br-mcp-server-app"
  
# aplication settings
  app_settings = {
    BITS_DB_SERVER   = var.bits_database_config.URL
    BITS_DB_DATABASE = var.bits_database_config.DB_NAME
    BITS_DB_USERNAME = var.bits_database_config.USERNAME
    BITS_DB_PWD      = var.bits_database_config.PASSWORD
  }
  
  subnet_id = module.vnet.subnet_id

}