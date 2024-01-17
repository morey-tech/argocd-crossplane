#!/bin/bash

echo "post-start start" >> ~/status

# this runs in background each time the container starts

# kind delete cluster --name argocd-crossplane
kind export kubeconfig --name argocd-crossplane

echo "post-start complete" >> ~/status
