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
