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

  provisioner "file" {
    source      = "${path.module}/scripts/install_k3s.sh"
    destination = "/tmp/install_k3s.sh"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_k3s.sh",
      "/tmp/install_k3s.sh"
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }

  # Aguardar alguns segundos para garantir que o k3s está rodando e o token foi gerado
  provisioner "remote-exec" {
    inline = ["sleep 10"]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }
}

data "external" "k3s_token" {
  depends_on = [aws_instance.control_plane]
  program = ["sh", "-c", "ssh -i ${var.private_key_path} -o StrictHostKeyChecking=no ubuntu@${aws_instance.control_plane.public_ip} 'sudo cat /var/lib/rancher/k3s/server/node-token' | jq -R '{token: .}'"]
}

resource "aws_instance" "worker" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.k3s.id]
  key_name      = aws_key_pair.deployer.key_name
  tags = { Name = "k3s-worker" }

  provisioner "file" {
    source      = "${path.module}/scripts/join_k3s.sh"
    destination = "/tmp/join_k3s.sh"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/join_k3s.sh",
      "/tmp/join_k3s.sh ${aws_instance.control_plane.private_ip} '${data.external.k3s_token.result.token}'"
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }
}
