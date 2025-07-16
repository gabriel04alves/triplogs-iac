data "aws_eks_cluster_auth" "triplogs" {
  name = aws_eks_cluster.triplogs.name
}