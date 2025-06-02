variable "default_location" {
    type    = string
}

variable "name" {
    type = string
}

variable "rg_name" {
    type = string
    description = "value of the resource group name"
}

variable "allowed_ips" {
  description = "List of IP addresses allowed to access the MCP server on port 8000"
  type        = list(string)
  default     = []
}