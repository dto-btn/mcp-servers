variable "default_location" {
    type    = string
    default = "canadacentral"
}

variable "allowed_origins" {
  description = "List of origins allowed for CORS"
  type        = list(string)
  default     = ["*"]
}

variable "bits_database_config" {
  description = "Configuration for the database connection"
  type = object({
    URL      = string
    DB_NAME  = string
    USERNAME = string
    PASSWORD = string
  })
  default = null
  sensitive = true
}

variable "allowed_ips" {
  description = "List of IP addresses allowed to access the MCP server on port 8000, this is devs only"
  type        = list(string)
  default     = []
}