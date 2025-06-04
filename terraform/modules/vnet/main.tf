/****************************************************
*                       VNET                        *
*****************************************************/
resource "azurerm_network_security_group" "main" {
  name                = "${var.name}-sg"
  location            = var.default_location
  resource_group_name = var.rg_name
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.name}-vnet"
  location            = var.default_location
  resource_group_name = var.rg_name
  address_space       = [ "10.2.0.0/16" ]
  //Using Azure's Default DNS IP. Has to be defined in case it was changed.
  dns_servers         = [] # 168.63.129.16 <- will set to this value which is the AzureDNS
}

resource "azurerm_subnet" "frontend" {
    name                  = "frontend"
    address_prefixes      = ["10.2.0.0/20"]
    virtual_network_name  = azurerm_virtual_network.main.name
    resource_group_name   = var.rg_name

    delegation {
      name = "Microsoft.Web.serverFarms"

      service_delegation {
        name    = "Microsoft.Web/serverFarms"
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
}

resource "azurerm_subnet_network_security_group_association" "frontend" {
  network_security_group_id  = azurerm_network_security_group.main.id
  subnet_id                  = azurerm_subnet.frontend.id
}

# # Create allow rules for each provided IP address
# resource "azurerm_network_security_rule" "allow_specific_ips" {
#   count                       = length(var.allowed_ips)
#   name                        = "allow-ip-${count.index}"
#   priority                    = 100 + count.index
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "443"
#   source_address_prefix       = "${var.allowed_ips[count.index]}"
#   destination_address_prefix  = "*"
#   resource_group_name         = var.rg_name
#   network_security_group_name = azurerm_network_security_group.main.name
# }

# # Deny all other traffic to port 8000
# resource "azurerm_network_security_rule" "deny_all" {
#   name                        = "deny-all-port-443"
#   priority                    = 4000
#   direction                   = "Inbound"
#   access                      = "Deny"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "443"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = var.rg_name
#   network_security_group_name = azurerm_network_security_group.main.name
# }