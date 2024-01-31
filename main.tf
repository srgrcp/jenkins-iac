resource "azurerm_public_ip" "jenkins-pi" {
  name                = "jenkins-public-ip"
  location            = azurerm_resource_group.jenkins-rs.location
  resource_group_name = azurerm_resource_group.jenkins-rs.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "jenkins-ni" {
  name                = "jenkins-sn"
  location            = azurerm_resource_group.jenkins-rs.location
  resource_group_name = azurerm_resource_group.jenkins-rs.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.jenkins-sn.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jenkins-pi.id
  }
}

resource "azurerm_linux_virtual_machine" "jenkins-vm" {
  name                = var.HOSTNAME
  resource_group_name = azurerm_resource_group.jenkins-rs.name
  location            = azurerm_resource_group.jenkins-rs.location
  size                = "Standard_B1s"

  computer_name  = var.HOSTNAME
  admin_username = var.USER

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  network_interface_ids = [
    azurerm_network_interface.jenkins-ni.id
  ]

  admin_ssh_key {
    username   = var.USER
    public_key = azurerm_ssh_public_key.jenkins-key.public_key
  }

  connection {
    host        = self.public_ip_address
    type        = "ssh"
    user        = "ubuntu"
    private_key = var.PRIVATE_KEY_CONTENT
  }

  provisioner "remote-exec" {
    inline = [
      "echo '👍'"
    ]
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i ${self.public_ip_address}, --private-key ansible/jenkins-key.pem ansible/setup-jenkins.yml"
  }
}
