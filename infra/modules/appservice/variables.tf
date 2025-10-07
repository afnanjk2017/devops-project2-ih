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

variable "fe_port" {
  type        = number
  description = "Port number of the frontend"
}
variable "be_port" {
  type        = number
  description = "Port number of the backend"
}

variable "db_server" {
  type        = string
  description = "Database server FQDN"
}

variable "db_name" {
  type        = string
  description = "Database name"
}

variable "db_user" {
  type        = string
  description = "Database username"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Database password"
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
  description = "ID of the agw subnet"
}
variable "subnet_agw_cidr" {
  type        = string
  description = "CIDR of the agw subnet"
}
variable "fe_app_id" {
  type        = string
  description = "ID of the frontend container app"
}
variable "be_app_id" {
  type        = string
  description = "ID of the backend container app"
}
variable "vnet_id" {
  type        = string
  description = "ID of the VNet"
}
variable "private_endpoint_subnet_id" {
  type        = string
  description = "ID of PE subnet"
}
variable "mssql_server_name" {
  type        = string
  description = "Name of Azure SQL server"
}
variable "agw_ip" {
  type        = string
  description = "IP of AGW"
}
variable "be_image_name_and_tag" {
  type        = string
  description = "The name and tag of the backend image on dockerhub: username/image:tag"
}
variable "fe_image_name_and_tag" {
  type        = string
  description = "The name and tag of the frontend image on dockerhub: username/image:tag"
}
