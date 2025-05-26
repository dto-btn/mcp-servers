variable "default_location" {
    type    = string
    default = "canadacentral"
}

variable "resource_group_name" {
  type = string
  description = "Name of the resource group to deploy the app into."
}

variable "app_name" {
  type = string
  description = "Name of the Azure Web App."
  default = "mcp-webapp"
}

variable "app_settings" {
  description = "Additional app settings to apply to the web app"
  type        = map(string)
  default     = {}
}

variable "allowed_origins" {
  description = "List of origins allowed for CORS"
  type        = list(string)
  default     = ["*"]
}

variable "frontend_app_ip" {
  description = "IP address of the frontend application that should be allowed to access"
  type        = string
}

variable "developer_ip_addresses" {
  description = "List of developer IP addresses allowed to access the app"
  type        = list(string)
  default     = []
}

variable "enable_vnet_integration" {
  description = "Whether to enable VNet integration for more secure networking"
  type        = bool
  default     = false
}

# ACR credentials
variable "acr_admin_username" {
  description = "The admin username for the Azure Container Registry"
  type        = string
}

variable "acr_admin_password" {
  description = "The admin password for the Azure Container Registry"
  type        = string
  sensitive   = true
}

variable "acr_login_server" {
  description = "The login server URL for the Azure Container Registry"
  type        = string
}

# Source code repository
variable "repo_url" {
  description = "URL of the Git repository containing the application code"
  type        = string
  default     = null
}

variable "branch" {
  description = "Branch of the repository to use"
  type        = string
  default     = "main"
}
