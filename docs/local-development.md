# Local Development Guide

This guide helps developers set up a local development environment for the CSI project.

## Prerequisites

- Docker Desktop
- LocalStack
- AWS CLI
- Terraform >= 1.0.0
- kubectl
- helm
- Node.js >= 14 (for frontend development)
- Java 11 (for backend development)
- Maven or Gradle

## Setup Steps

### 1. Clone the Repository

```bash
git clone https://github.com/your-org/csi-project.git
cd csi-project
```

### 2. Start LocalStack

```bash
# For Linux/macOS
./scripts/setup-localstack.sh

# For Windows
./scripts/setup-localstack.ps1
```

### 3. Initialize Terraform with LocalStack Backend

```bash
terraform init -reconfigure -backend-config=backend.localstack.hcl
```

### 4. Apply Terraform Configuration

```bash
terraform apply -var-file=localstack.tfvars
```

### 5. Configure kubectl

For LocalStack, you'll need to manually create a kubeconfig file:

```bash
mkdir -p ~/.kube
cat > ~/.kube/config-localstack << EOF
apiVersion: v1
kind: Config
clusters:
- cluster:
    server: http://localhost:4566
  name: localstack-eks
contexts:
- context:
    cluster: localstack-eks
    user: localstack-user
  name: localstack
current-context: localstack
users:
- name: localstack-user
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws
      args:
        - --endpoint-url=http://localhost:4566
        - eks
        - get-token
        - --cluster-name
        - csi-eks-cluster
EOF

export KUBECONFIG=~/.kube/config-localstack
```

### 6. Deploy Kubernetes Resources

```bash
kubectl apply -f kubernetes/
```

### 7. Frontend Development

```bash
cd frontend
npm install
npm start
```

The frontend will be available at http://localhost:4200

### 8. Backend Development

```bash
cd backend
./mvnw spring-boot:run
```

The backend API will be available at http://localhost:8080

### 9. Access Services

- Frontend: http://localhost:4200
- Backend API: http://localhost:8080
- Grafana: http://localhost:3000 (admin/admin)
- Prometheus: http://localhost:9090

## Testing

### Run Infrastructure Tests

```bash
cd tests
go test -v
```

### Run Frontend Tests

```bash
cd frontend
npm test
```

### Run Backend Tests

```bash
cd backend
./mvnw test
```