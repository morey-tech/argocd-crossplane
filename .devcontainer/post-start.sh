#!/bin/bash

echo "post-start start" >> ~/status

# this runs in background each time the container starts

# kind delete cluster --name argocd-crossplane
kind export kubeconfig --name argocd-crossplane

# configure ingress
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.1/deploy/static/provider/kind/deploy.yaml
kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s 

kustomize build argocd/ | kubectl apply -f -

echo "post-start complete" >> ~/status
