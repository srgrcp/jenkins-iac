variable "REGION" {
  default = "us-east-1"
}

variable "KEY_PAIR_NAME" {
  default = "jenkins-key"
}

variable "PRIVATE_KEY_CONTENT" {
  sensitive = true
}

variable "PUB_KEY_CONTENT" {
  sensitive = true
}

variable "UBUNTU_22_AMI" {
  default = "ami-0c7217cdde317cfec"
}

variable "USER" {
  default = "ubuntu"
}
