
#!/bin/bash
set -e

# Instala o k3s server (control-plane)
curl -sfL https://get.k3s.io | sh -s - server --node-taint CriticalAddonsOnly=true:NoExecute

# Exporta o token para uso pelo worker
sudo cat /var/lib/rancher/k3s/server/node-token > /tmp/node-token
