resource "azurerm_ssh_public_key" "jenkins-key" {
  name                = var.KEY_PAIR
  resource_group_name = azurerm_resource_group.jenkins-rs.name
  location            = azurerm_resource_group.jenkins-rs.location
  public_key          = var.PUB_KEY_CONTENT
}
