
resource "azurerm_resource_group" "main-rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
  tags = {
    "provisioner" = "${lower(replace(var.author, " ", "-"))}-terraform"
  }
}
