variable "default_location" {
    type    = string
    default = "canadacentral"
}

variable "resource_group_name" {
  type = string
  description = "Name of the resource group to deploy the container group into."
}

variable "container_group_name" {
  type = string
  description = "Name of the Azure Container Group."
  default = "mcp-containergroup"
}

variable "containers" {
  description = "List of containers to deploy in the group. Each item should be an object with name, image, cpu, memory, and optionally environment variables and hostname."
  type = list(object({
    name      = string
    image     = string
    cpu       = number
    memory    = number
    hostname  = optional(string)
    env_vars  = optional(map(string))
    ports     = optional(list(number))
  }))
}

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