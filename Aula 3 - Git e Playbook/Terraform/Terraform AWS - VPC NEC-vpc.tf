terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.60.0"
    }
  }
}

provider "aws" {
  region                   = "us-east-1"
  shared_config_files      = ["C:/Users/danilo.sibov/.aws/config"]
  shared_credentials_files = ["C:/Users/danilo.sibov/.aws/credentials"]

  default_tags {
    tags = {
      owner   = "AWS"
      maneged = "Terraform134"
    }
  }

}

resource "aws_vpc" "nec-vpc2" {

  cidr_block = "172.18.0.0/16"
  tags = {
    Name = "nec-vpc2"
  }
}

resource "aws_subnet" "Subnet_Publica" {
  vpc_id                  = aws_vpc.nec-vpc2.id
  cidr_block              = "172.18.1.0/24"
  availability_zone       = "us-east-1a" # Substitua pela sua zona de disponibilidade desejada
  map_public_ip_on_launch = true
  tags = {
    Name = "Subnet_Publica"
  }
}

resource "aws_subnet" "Subnet_Privada" {
  vpc_id            = aws_vpc.nec-vpc2.id
  cidr_block        = "172.18.2.0/24"
  availability_zone = "us-east-1a" # Substitua pela sua zona de disponibilidade desejada
  tags = {
    Name = "Subnet_Privada"
  }
}

resource "aws_internet_gateway" "nec_igw" {
  vpc_id = aws_vpc.nec-vpc2.id
  tags = {
    Name = "nec IGW"
  }
}

resource "aws_route_table" "Tabela_rota_publica" {
  vpc_id = aws_vpc.nec-vpc2.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nec_igw.id
  }
  tags = {
    Name = "Tabela_rota_publica"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.Subnet_Publica.id
  route_table_id = aws_route_table.Tabela_rota_publica.id
}