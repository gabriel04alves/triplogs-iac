#!/bin/bash
set -e

# Instala Helm, se não existir
if ! command -v helm &> /dev/null; then
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

# Aguarda o k3s estar pronto
until kubectl get nodes; do sleep 2; done

# Adiciona o repositório do ArgoCD
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

# Instala o ArgoCD na namespace argocd
kubectl create namespace argocd || true
helm upgrade --install argocd argo/argo-cd --namespace argocd --set server.service.type=LoadBalancer
