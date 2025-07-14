
output "control_plane_public_ip" {
  value = aws_instance.control_plane.public_ip
  description = "Public IP of the k3s control-plane node"
}

output "worker_public_ip" {
  value = aws_instance.worker.public_ip
  description = "Public IP of the k3s worker node"
}

output "vpc_id" {
  value = aws_vpc.main.id
  description = "VPC ID"
}
