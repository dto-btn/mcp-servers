variable "default_location" {
    type    = string
    default = "canadacentral"
}

variable "rg_name" {
  type = string
  description = "Name of the resource group to deploy the app into."
}

variable "name" {
  type = string
  description = "Name of the Azure Web App."
}

variable "app_settings" {
  description = "Configuration for the application"
  type = map(string)
  default = {}
  sensitive = true
}

variable "subnet_id" {
  type = string
  description = "ID of the subnet where the app will be deployed."
}