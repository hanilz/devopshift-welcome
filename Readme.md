# Welcome To Hanil Zarbailov's Docker, Docker-Compose and K8S Exam Repo

## Docker-Compose Task
Files are in `exam-code/docker`.

For creating: 
```bash
docker-compose up -d
```

For destroying: 
```bash
docker-compose down -v
```

## Kubernetes Task
Files are in `exam-code/kubernetes`

backend service: 
```bash
kubectl apply -f exam-be-deployment.yaml
```

frontend service: 
```bash
kubectl apply -f exam-fe-deployment.yaml
```

mysql service: 
```bash
kubectl apply -f exam-mysql-deployment.yaml
```
