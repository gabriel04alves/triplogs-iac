# TripLogs Infrastructure as Code (IaC)

Este repositório foi desenvolvido durante a **disciplina de Fundamentos de DevOps** no **curso de Bacharelado em Sistemas de Informação** no **Instituto Federal Catarinense Campus Araquari**. Contém a infraestrutura como código para a aplicação TripLogs, utilizando Terraform para provisionamento da infraestrutura AWS e Kubernetes manifests para deploy das aplicações.

## Visão Geral

O TripLogs é uma aplicação web full-stack para registro e gerenciamento de experiências de viagem, permitindo que usuários documentem suas aventuras com fotos, descrições detalhadas e dados de localização. O sistema oferece uma experiência moderna e intuitiva para criar, editar e visualizar histórias de viagem.

### Componentes da Aplicação

- **Frontend**: Aplicação Vue.js 3 com interface moderna usando Vuetify e Material Design
- **Backend**: API REST em Django REST Framework com autenticação JWT
- **Banco de Dados**: PostgreSQL hospedado no AWS RDS
- **Orquestração**: Kubernetes (EKS) para gerenciamento de containers
- **GitOps**: ArgoCD para deploy contínuo
- **Infraestrutura**: AWS (VPC, EKS, RDS, Load Balancers)

### Funcionalidades da Aplicação

#### Frontend (Vue.js 3)

- **Interface Moderna**: Design responsivo com Vuetify e Material Design Icons
- **Gerenciamento de Estado**: Pinia para controle de estado reativo
- **Autenticação**: Sistema completo de login/registro com validação em tempo real
- **CRUD de Viagens**: Criar, editar, visualizar e excluir registros de viagem
- **Busca Inteligente**: Pesquisar viagens por título ou localização
- **Upload de Imagens**: Suporte para fotos das viagens
- **Estados de UI**: Loading, empty state e tratamento de erros

#### Backend (Django REST Framework)

- **API REST**: Endpoints completos para autenticação e gerenciamento de viagens
- **Autenticação JWT**: Tokens seguros com refresh automático
- **Modelo de Usuário Customizado**: Sistema de usuários com email como identificador
- **Modelo de Viagens**: Estrutura completa para armazenamento de dados de viagem
- **Documentação Automática**: Swagger/OpenAPI para documentação da API
- **CORS Configurado**: Pronto para integração com frontend
- **Validação de Permissões**: Usuários só podem gerenciar suas próprias viagens

## Repositórios do Projeto

- **Frontend**: [gabriel04alves/triplogs-frontend](https://github.com/gabriel04alves/triplogs-frontend)
- **Backend**: [gabriel04alves/triplogs-backend](https://github.com/gabriel04alves/triplogs-backend)
- **Infraestrutura**: [gabriel04alves/triplogs-iac](https://github.com/gabriel04alves/triplogs-iac) (este repositório)

## Arquitetura do Sistema

### Stack Tecnológico

#### Frontend

- **Vue.js 3**: Framework JavaScript progressivo com Composition API
- **Vuetify 3**: Framework de componentes Material Design
- **Vite**: Build tool moderna para desenvolvimento rápido
- **Pinia**: Store para gerenciamento de estado
- **Vue Router**: Roteamento oficial do Vue
- **Axios**: Cliente HTTP para comunicação com a API

#### Backend

- **Django 5.1**: Framework web Python de alto nível
- **Django REST Framework**: Toolkit para desenvolvimento de APIs REST
- **PostgreSQL**: Banco de dados relacional principal
- **JWT (Simple JWT)**: Autenticação via tokens JSON Web Token
- **Cloudinary**: Armazenamento de imagens em nuvem
- **drf-spectacular**: Geração automática de documentação OpenAPI

#### DevOps & Infraestrutura

- **Terraform**: Infrastructure as Code para provisionamento AWS
- **Kubernetes (EKS)**: Orquestração de containers
- **ArgoCD**: GitOps para deploy contínuo
- **AWS**: Plataforma de nuvem (VPC, EKS, RDS, Load Balancers)
- **Docker**: Containerização das aplicações

### Arquitetura AWS

- **VPC**: Rede privada com CIDR 10.0.0.0/16
- **Subnets**:
  - 2 subnets públicas (us-east-1a, us-east-1b) para EKS nodes
  - 2 subnets privadas (us-east-1a, us-east-1b) para RDS
- **EKS Cluster**: Cluster Kubernetes gerenciado
- **RDS PostgreSQL**: Banco de dados em subnet privada
- **LoadBalancers**: Para exposição dos serviços frontend e backend

## Estrutura do Projeto

```
├── README.md
├── terraform/                 # Infraestrutura AWS
│   ├── main.tf               # Recursos principais (VPC, EKS, RDS)
│   ├── providers.tf          # Configuração dos providers
│   ├── variables.tf          # Variáveis do Terraform
│   ├── outputs.tf            # Outputs da infraestrutura
│   ├── data.tf               # Data sources
│   └── argocd-values.yaml    # Configuração do ArgoCD
└── k8s/                      # Manifests Kubernetes
    ├── kustomization.yaml    # Kustomize principal
    ├── backend/              # Manifests do backend
    │   ├── deployment.yaml
    │   ├── service.yaml
    │   ├── configmap.yaml
    │   └── kustomization.yaml
    └── frontend/             # Manifests do frontend
        ├── deployment.yaml
        ├── service.yaml
        ├── configmap.yaml
        └── kustomization.yaml
```

## Pré-requisitos

Antes de começar, certifique-se de ter as seguintes ferramentas instaladas:

### Ferramentas Essenciais

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [AWS CLI](https://aws.amazon.com/cli/) configurado
- [Git](https://git-scm.com/)

### Credenciais AWS

Você precisará de credenciais AWS com permissões para:

- **EC2**: Criação e gerenciamento de instâncias
- **VPC**: Configuração de redes virtuais
- **EKS**: Gerenciamento de clusters Kubernetes
- **RDS**: Criação e configuração de bancos de dados
- **IAM**: Gerenciamento de roles e políticas
- **Load Balancers**: Configuração de balanceadores de carga

### Configuração Inicial

1. Configure suas credenciais AWS:

   ```bash
   aws configure
   ```

2. Verifique se o kubectl está funcionando:

   ```bash
   kubectl version --client
   ```

3. Verifique se o Terraform está instalado:
   ```bash
   terraform version
   ```

## Instalação e Deploy

### 1. Deploy da Infraestrutura

```bash
# Clone o repositório
git clone https://github.com/gabriel04alves/triplogs-iac.git
cd triplogs-iac

# Navegue para o diretório terraform
cd terraform

# Inicialize o Terraform
terraform init

# Crie um arquivo terraform.tfvars com suas configurações
cat > terraform.tfvars << EOF
db_password = "sua_senha_segura_aqui"
db_username = "postgres"
db_name = "triplogs"
EOF

# Planeje as mudanças
terraform plan

# Aplique a infraestrutura
terraform apply
```

### 2. Configuração do kubectl

```bash
# Configure o kubectl para se conectar ao cluster EKS
aws eks update-kubeconfig --region us-east-1 --name triplogs
```

### 3. Deploy das Aplicações

O deploy inclui duas aplicações containerizadas:

#### Backend (TripLogs API)

- **Imagem**: `ghcr.io/gabriel04alves/triplogs-backend:latest`
- **Porta**: 3000
- **Funcionalidades**:
  - API REST com Django REST Framework
  - Autenticação JWT
  - CRUD completo para viagens
  - Sistema de usuários customizado
  - Documentação Swagger automática

#### Frontend (Interface Web)

- **Imagem**: `ghcr.io/gabriel04alves/triplogs-frontend:latest`
- **Porta**: 80
- **Funcionalidades**:
  - Interface Vue.js 3 com Vuetify
  - Autenticação segura
  - Gerenciamento de viagens
  - Busca e filtros
  - Upload de imagens

```bash
# Navegue para o diretório k8s
cd ../k8s

# Aplique os manifests usando Kustomize
kubectl apply -k .

# Verifique o status dos pods
kubectl get pods

# Verifique os serviços
kubectl get services
```

### 4. Acesso ao ArgoCD

```bash
# Obtenha a URL do ArgoCD
kubectl get svc -n argocd

# Obtenha a senha inicial do admin
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

## Configuração

### Variáveis do Terraform

| Variável      | Descrição                | Padrão      | Obrigatório |
| ------------- | ------------------------ | ----------- | ----------- |
| `region`      | Região AWS               | `us-east-1` | Não         |
| `db_name`     | Nome do banco PostgreSQL | `triplogs`  | Não         |
| `db_username` | Usuário do banco         | `postgres`  | Não         |
| `db_password` | Senha do banco           | -           | **Sim**     |
| `db_port`     | Porta do banco           | `5432`      | Não         |
| `debug`       | Modo debug               | `False`     | Não         |

### Configurações das Aplicações

#### Variáveis de Ambiente do Backend

As configurações do backend são gerenciadas através de ConfigMaps e Secrets:

**ConfigMap (Backend)**:

- `MODE`: Modo de execução (production)
- `DEBUG`: Modo debug (False)
- `MY_IP`: IP da aplicação
- `ALLOWED_HOSTS`: Hosts permitidos
- `CORS_ALLOWED_ORIGINS`: Origens CORS permitidas

**Secrets (Banco de Dados)**:

- `DB_NAME`: Nome do banco de dados
- `DB_USER`: Usuário do PostgreSQL
- `DB_PASSWORD`: Senha do banco
- `DB_HOST`: Endpoint do RDS
- `DB_PORT`: Porta do banco (5432)

#### Configuração do Frontend

O frontend consome a API através de variáveis configuradas dinamicamente:

- **URL da API**: Configurada automaticamente via service discovery
- **Modo de Produção**: Build otimizado para produção
- **Proxy Reverso**: Nginx configurado para servir a aplicação Vue.js

### Estrutura de Secrets no Kubernetes

O projeto utiliza o secret `app-secrets` que é criado automaticamente pelo Terraform com as informações do banco RDS:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secrets
  namespace: default
type: Opaque
data:
  DB_HOST: <endpoint-rds-base64>
  DB_PORT: <porta-base64>
  DB_NAME: <nome-banco-base64>
  DB_USER: <usuario-base64>
  DB_PASSWORD: <senha-base64>
```

## Monitoramento e Troubleshooting

### Verificar Status da Infraestrutura

```bash
# Status do cluster EKS
kubectl cluster-info

# Status dos nodes
kubectl get nodes

# Status dos pods em todos os namespaces
kubectl get pods --all-namespaces

# Status específico das aplicações
kubectl get pods -l app=triplogs-backend
kubectl get pods -l app=triplogs-frontend

# Verificar services e endpoints
kubectl get services
kubectl get endpoints
```

### Logs das Aplicações

```bash
# Logs do backend
kubectl logs -f deployment/triplogs-backend

# Logs do frontend
kubectl logs -f deployment/triplogs-frontend

# Logs com filtro por tempo
kubectl logs deployment/triplogs-backend --since=1h

# Logs de todos os pods de uma aplicação
kubectl logs -l app=triplogs-backend --all-containers=true
```

### Verificar Conectividade do Banco

```bash
# Verificar secret do banco
kubectl get secret app-secrets -o yaml

# Teste de conectividade dentro do pod do backend
kubectl exec -it deployment/triplogs-backend -- sh -c "
echo 'Testando conexão com PostgreSQL...'
python -c \"
import os
import psycopg2
try:
    conn = psycopg2.connect(
        host=os.environ['DB_HOST'],
        port=os.environ['DB_PORT'],
        database=os.environ['DB_NAME'],
        user=os.environ['DB_USER'],
        password=os.environ['DB_PASSWORD']
    )
    print('✅ Conexão com banco bem-sucedida!')
    conn.close()
except Exception as e:
    print(f'❌ Erro na conexão: {e}')
\"
"
```

### Verificar Status do ArgoCD

```bash
# Verificar pods do ArgoCD
kubectl get pods -n argocd

# Verificar serviços do ArgoCD
kubectl get svc -n argocd

# Obter URL externa do ArgoCD (se LoadBalancer)
kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'

# Senha inicial do admin
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

## Recursos Adicionais

### Documentação Oficial

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Amazon EKS User Guide](https://docs.aws.amazon.com/eks/latest/userguide/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)

### Repositórios Relacionados

- **Frontend**: [gabriel04alves/triplogs-frontend](https://github.com/gabriel04alves/triplogs-frontend)
- **Backend**: [gabriel04alves/triplogs-backend](https://github.com/gabriel04alves/triplogs-backend)

### Tecnologias Utilizadas

- **Terraform**: 1.5+
- **Kubernetes**: 1.27+
- **AWS EKS**: 1.27
- **PostgreSQL**: 14.12
- **ArgoCD**: 5.46.7
- **Vue.js**: 3.x
- **Django**: 5.1

## Suporte e Contato

### Reportar Problemas

- Abra uma [issue](https://github.com/gabriel04alves/triplogs-iac/issues) neste repositório
- Descreva o problema com detalhes
- Inclua logs relevantes e informações do ambiente

---

Este projeto foi desenvolvido como parte do curso de **Bacharelado em Sistemas de Informação** no **Instituto Federal Catarinense Campus Araquari**.
