/****************************************************
*               RBAC ASSIGNMENTS                   *
*****************************************************/

# Data source to get user object ID from email
data "azuread_user" "monarch_wadia" {
  user_principal_name = "monarch.wadia@ssc-spc.gc.ca"
}

# Contributor role assignment for rag-mcp-server
resource "azurerm_role_assignment" "rag_mcp_server_contributor" {
  scope                = module.rag-mcp-server.web_app_id
  role_definition_name = "Contributor"
  principal_id         = data.azuread_user.monarch_wadia.object_id

  depends_on = [module.rag-mcp-server]
}
