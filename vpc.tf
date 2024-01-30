data "aws_region" "current" {}

resource "aws_vpc" "jenkins-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "Jenkins VPC"
  }
}

resource "aws_internet_gateway" "jenkins-gateway" {
  vpc_id = aws_vpc.jenkins-vpc.id
}

resource "aws_subnet" "jenkins-subnet" {
  vpc_id            = aws_vpc.jenkins-vpc.id
  cidr_block        = aws_vpc.jenkins-vpc.cidr_block
  availability_zone = "${data.aws_region.current.name}a"
}

resource "aws_route_table" "jenkins-route-table" {
  vpc_id = aws_vpc.jenkins-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jenkins-gateway.id
  }
}

resource "aws_route_table_association" "jenkins-route-table-association" {
  subnet_id      = aws_subnet.jenkins-subnet.id
  route_table_id = aws_route_table.jenkins-route-table.id
}
