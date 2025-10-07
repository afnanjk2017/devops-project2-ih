variable "rg_name" {
  type        = string
  description = "resource group name"
}
variable "rg_location" {
  type        = string
  description = "resource group location"
}

variable "vnet_name" {
  type        = string
  description = "Name of the VNet"
}
variable "vnet_id" {
  type        = string
  description = "ID of the VNet"
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
variable "rg_id" {
  type        = string
  description = "RG ID"
}
