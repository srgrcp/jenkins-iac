terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-rg"
    storage_account_name = "terraformsasrgrcp"
    container_name       = "jenkins-tfstate"
    key                  = "terraform.tfstate"
  }
}
