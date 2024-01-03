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

### List the Applications
```
argocd app list
```

argocd-crossplane output:
```
NAME                   CLUSTER     NAMESPACE       PROJECT  STATUS  HEALTH   SYNCPOLICY  CONDITIONS  REPO                                               PATH                    TARGET
argocd/bootstrap       in-cluster  argocd          default  Synced  Healthy  Auto-Prune  <none>      https://github.com/akuity/declarative-argocd-crossplane      apps/                   HEAD
argocd/helm-guestbook  -argocd-crossplane        helm-guestbook  default  Synced  Healthy  Auto-Prune  <none>      https://github.com/morey-tech/argocd-argocd-crossplane-apps  general/helm-guestbook  HEAD
argocd/sync-waves      -argocd-crossplane        sync-waves      default  Synced  Healthy  Auto-Prune  <none>      https://github.com/morey-tech/argocd-argocd-crossplane-apps  general/sync-waves      HEAD
```
