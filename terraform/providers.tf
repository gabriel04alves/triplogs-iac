provider "aws" {
  region  = "us-east-1"
}

provider "helm" {
  kubernetes = {
    host                   = aws_eks_cluster.triplogs.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.triplogs.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.triplogs.token
  }
}

provider "kubernetes" {
  host                   = aws_eks_cluster.triplogs.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.triplogs.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.triplogs.token
}