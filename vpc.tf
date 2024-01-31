resource "azurerm_virtual_network" "jenkins-vn" {
  name                = "jenkins-vn"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.jenkins-rs.location
  resource_group_name = azurerm_resource_group.jenkins-rs.name
}

resource "azurerm_subnet" "jenkins-sn" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.jenkins-rs.name
  virtual_network_name = azurerm_virtual_network.jenkins-vn.name
  address_prefixes     = ["10.0.2.0/24"]
}
