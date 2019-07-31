# docker build -t onxssis/birdboard-app-k8s:latest -t onxssis/birdboard-app-k8s:$SHA -f "Dockerfile" .

# docker push onxssis/birdboard-app-k8s:latest

# docker push onxssis/birdboard-app-k8s:$SHA

# kubectl apply -f k8s
# kubectl set image deployments/birdboard-deployment birdboard=onxssis/birdboard-app-k8s:$SHA

kubectl delete -f k8s