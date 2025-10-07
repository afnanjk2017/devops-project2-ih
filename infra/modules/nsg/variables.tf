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
variable "be_app_id" {
  type        = string
  description = "ID of the backend container app"
}
variable "db_id" {
  type        = string
  description = "ID of the database"
}

variable "subnet_fe_cidr" {
  type        = list(string)
  description = "CIDR of frontend subnet"
}
variable "subnet_be_cidr" {
  type        = list(string)
  description = "CIDR of backend subnet"
}
variable "subnet_agw_cidr" {
  type        = list(string)
  description = "CIDR of agw subnet"
}
variable "subnet_pe_cidr" {
  type        = list(string)
  description = "CIDR of private endpoints subnet"
}
variable "subnet_db_cidr" {
  type        = list(string)
  description = "CIDR of database subnet"
}

variable "subnet_fe_id" {
  type        = string
  description = "ID of the frontend subnet"
}
variable "subnet_be_id" {
  type        = string
  description = "ID of the backend subnet"
}
variable "subnet_agw_id" {
  type        = string
  description = "ID of the app GW subnet"
}
variable "subnet_db_id" {
  type        = string
  description = "ID of the DB subnet"
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

variable "be_port" {
  type        = number
  description = "Port number for backend"
}
variable "fe_port" {
  type        = number
  description = "Port number for frontend"
}
