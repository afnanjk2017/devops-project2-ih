variable "ARM_SUBSCRIPTION_ID" {
  type        = string
  description = "Azure RM sub ID"
}
variable "db_password" {
  type        = string
  sensitive   = true
  description = "Password for the MSSQL Database"
}
variable "author" {
  type        = string
  description = "Author of the resources"
}
variable "resource_prefix" {
  type        = string
  description = "Resource prefix to add to the names"
}
variable "resource_group_location" {
  type        = string
  description = "Resource group location"
}
variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}
variable "contact_person_name" {
  type        = string
  description = "Name of contact person in case of alert"
}
variable "contact_person_email" {
  type        = string
  description = "Email of contact person in case of alert"
}
variable "be_port" {
  type        = number
  description = "Port number for backend"
  default     = 80
}
variable "fe_port" {
  type        = number
  description = "Port number for frontend"
  default     = 80
}

variable "db_admin" {
  type = string
}
variable "be_image_name_and_tag" {
  type        = string
  description = "The name and tag of the backend image on dockerhub: username/image:tag"
}
variable "fe_image_name_and_tag" {
  type        = string
  description = "The name and tag of the frontend image on dockerhub: username/image:tag"
}
