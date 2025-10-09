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

variable "fe_app_id" {
  type        = string
  description = "ID of the frontend container app"
}
variable "app_gateway_id" {
  type        = string
  description = "ID of the  gateway"
}
variable "be_app_id" {
  type        = string
  description = "ID of the backend container app"
}
variable "db_id" {
  type        = string
  description = "ID of the database"
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
variable "contact_person_name" {
  type        = string
  description = "Information about who to contact"
}
variable "contact_person_email" {
  type        = string
  description = "Information about who to contact"
}

variable "service_plan_be_id" {
  type        = string
  description = "service plan ID to scale"
}
variable "service_plan_be_name" {
  type        = string
  description = "service plan ID to scale"
}
variable "service_plan_fe_id" {
  type        = string
  description = "service plan ID to scale"
}
variable "service_plan_fe_name" {
  type        = string
  description = "service plan ID to scale"
}
