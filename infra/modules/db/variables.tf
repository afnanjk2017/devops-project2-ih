variable "rg_name" {
  type        = string
  description = "resource group name"
}
variable "rg_location" {
  type        = string
  description = "resource group location"
}
variable "db_password" {
  type        = string
  sensitive   = true
  description = "resource group location"
}
variable "db_admin" {
  type        = string
  sensitive   = true
  description = "resource group location"
}
variable "vnet_id" {
  type        = string
  description = "ID of the virtual network"
}
variable "subnet_be_id" {
  type        = string
  description = "ID of the backend subnet"
}
variable "subnet_db_id" {
  type        = string
  description = "ID of the db subnet"
}
variable "private_endpoint_subnet_id" {
  type        = string
  description = "ID of the subnet"
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
  type = string
}
