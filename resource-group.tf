resource "azurerm_resource_group" "jenkins-rs" {
  name     = "jenkins-rs"
  location = var.LOCATION
}
