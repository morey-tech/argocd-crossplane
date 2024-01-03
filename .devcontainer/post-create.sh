#!/bin/bash

echo "post-create start" >> ~/status

# this runs in background after UI is available

echo alias k=kubectl >> /home/vscode/.bashrc
kind create cluster --config .devcontainer/kind-cluster.yaml

echo "post-create complete" >> ~/status
