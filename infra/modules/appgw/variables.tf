variable "rg_name" {
  type        = string
  description = "resource group name"
}
variable "rg_location" {
  type        = string
  description = "resource group location"
}

variable "author" {
  type        = string
  description = "Name of the author"
  default     = "terraform"
}
variable "resource_prefix" {
  type        = string
  description = "Prefix for resources"
  default     = "devops-tf"
}

variable "vnet_name" {
  type        = string
  description = "Name of the VNet"
}

variable "subnet_agw_id" {
  type        = string
  description = "ID of the AGW subnet"
}
variable "fe_app_id" {
  type        = string
  description = "ID of the frontend container app"
}
variable "be_app_id" {
  type        = string
  description = "ID of the backend container app"
}

variable "be_app_fqdn" {
  type        = string
  description = "FQDN of the backend container app"
}
variable "fe_app_fqdn" {
  type        = string
  description = "FQDN of the frontend container app"
}

variable "be_port" {
  type        = number
  description = "Port number for backend"
}
variable "fe_port" {
  type        = number
  description = "Port number for frontend"
}
