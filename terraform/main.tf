provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "triplogs-vpc" }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr
  availability_zone = var.aws_az
  map_public_ip_on_launch = true
  tags = { Name = "triplogs-subnet" }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "k3s" {
  name        = "k3s-sg"
  description = "Allow k3s, SSH, HTTP, HTTPS"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "control_plane" {
  ami           = var.ami_id
  instance_type = "t3.medium"
  subnet_id     = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.k3s.id]
  key_name      = aws_key_pair.deployer.key_name
  tags = { Name = "k3s-control-plane" }
}

resource "aws_instance" "worker" {
  ami           = var.ami_id
  instance_type = "t3.medium"
  subnet_id     = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.k3s.id]
  key_name      = aws_key_pair.deployer.key_name
  tags = { Name = "k3s-worker" }
}
