variable "LOCATION" {
  default = "East US 2"
}

variable "KEY_PAIR" {
  default = "jenkins-key"
}

variable "PRIVATE_KEY_CONTENT" {
  sensitive = true
}

variable "PUB_KEY_CONTENT" {
  sensitive = true
}

variable "HOSTNAME" {
  default = "jenkins"
}

variable "USER" {
  default = "ubuntu"
}
