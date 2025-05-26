variable "default_location" {
    type    = string
    default = "canadacentral"
}

variable "frontend_app_ip" {
  description = "IP address of the frontend application that should be allowed to access"
  type        = string
  default     = "0.0.0.0"
}

variable "developer_ip_addresses" {
  description = "List of developer IP addresses allowed to access the app"
  type        = list(string)
  default     = []
}

variable "allowed_origins" {
  description = "List of origins allowed for CORS"
  type        = list(string)
  default     = ["*"]
}