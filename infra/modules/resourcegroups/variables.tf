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
variable "resource_group_location" {
  type        = string
  description = "Resource group location"
  default     = "West US 2"
}
variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}
