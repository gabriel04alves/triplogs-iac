#!/bin/bash
set -e

# Token é passado como segundo parâmetro
K3S_TOKEN="${2}"

# Instala o k3s agent apontando para o control-plane
K3S_URL="https://${1}:6443"
curl -sfL https://get.k3s.io | K3S_URL=$K3S_URL K3S_TOKEN=$K3S_TOKEN sh -s - agent
