resource "aws_key_pair" "jenkins-key" {
  key_name   = var.KEY_PAIR_NAME
  public_key = var.PUB_KEY_CONTENT
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH traffic"
  vpc_id      = aws_vpc.jenkins-vpc.id
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}

resource "aws_security_group" "allow_http_8080" {
  name        = "allow_http"
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.jenkins-vpc.id
  ingress {
    description = "HTTP_8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}

resource "aws_instance" "jenkins-tf" {
  depends_on = [
    local_sensitive_file.private_key,
    local_file.ansible_inventory
  ]

  ami                         = var.UBUNTU_22_AMI
  instance_type               = "t3.small"
  associate_public_ip_address = true

  key_name  = aws_key_pair.jenkins-key.key_name
  subnet_id = aws_subnet.jenkins-subnet.id
  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id,
    aws_security_group.allow_http_8080.id
  ]

  tags = {
    Name = "jenkins-tf"
  }

  connection {
    host        = self.public_ip
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
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i ${self.public_ip}, --private-key ansible/jenkins-key.pem ansible/setup-jenkins.yml"
  }
}
