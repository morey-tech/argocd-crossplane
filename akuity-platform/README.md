# Akuity Platform

## Setup Steps
### Log into the `akuity` CLI.
```
akuity login
```
- Open the link displayed, enter the code.

## Set your organization name in the `akuity` config.
```
akuity config set --organization-name=<name>
```
- Replace `<name>` with your organization name.

### Create the Argo CD instance on the Akuity Platform.
```
akuity argocd apply -f akuity-platform/argocd-crossplane/
```

### Connect the clusters
Apply the agent install manifests to the cluster.
```
akuity argocd cluster get-agent-manifests --instance-name=argocd-crossplane -argocd-crossplane | kubectl apply -f -
```

### Log into the `argocd` CLI
```
argocd login \
    $(akuity argocd instance get argocd-crossplane -o json | jq -r '.id').cd.akuity.cloud \
    --username admin \
    --password akuity-argocd \
    --grpc-web
```
