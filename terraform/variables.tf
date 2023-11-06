variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "resource_group_location_db" {
  type        = string
  default     = "canadaeast"
  description = "Location of the resource group db."
}

variable "resource_group_location_front" {
  type        = string
  default     = "centralus"
  description = "Location of the resource group front."
}

variable "application_port" {
   description = "Port that you want to expose to the external load balancer"
   default     = 80
}

variable "front_port" {
   description = "Port that you want to expose for frontend"
   default     = 3000
}

variable "backend_port" {
   description = "Port that you want to expose for backend"
   default     = 3000
}

variable "resource_group_name_prefix_db" {
  type        = string
  default     = "rg_db"
  description = "Prefix of the resource group db name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "resource_group_name_prefix_front" {
  type        = string
  default     = "rg_front"
  description = "Prefix of the resource group db name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "username" {
  type        = string
  description = "The username for the local account that will be created on the new VM."
  default     = "azureadmin"
}
