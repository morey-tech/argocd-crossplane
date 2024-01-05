# Crossplane Manifests

## Handling of Crossplane CRDs
https://docs.crossplane.io/latest/software/install/#crossplane-deployment
> The Crossplane deployment starts with the crossplane-init container. The init container installs the Crossplane Custom Resource Definitions into the Kubernetes cluster.

```yaml
initContainers:
- args:
    - core
    - init
  image: 'xpkg.upbound.io/crossplane/crossplane:v1.14.4'
```

This behaviour where the init container from the Crossplane deployment creates the CRDs in the cluster impacts the sync of Argo CD Applications that create CRs from those CRDs (e.g. a Configuration). The sync will fail and retry until those CRDs are present, but if the crossplane deployment is in the same Applicaiton as one of the CRs that relies on the CRDs the init container creates, it will never apply the crossplane deployment. Since it won't apply anything until the CRDs exist for the resources in the Application.

With over services (e.g. cert-manager) the Application would contain the CRDs as manifests from the source which prevents this issue. The Application is aware of the CRDs required and applies them first, preventing the sync from getting stuck waiting on them.

References:
- [Thread on Crossplane Slack](https://crossplane.slack.com/archives/CEG3T90A1/p1704378818113409)
- [Crossplane issue discussing this problem](https://github.com/crossplane/crossplane/issues/4551)
- [Crossplane PR to add CRDs to Helm chart](https://github.com/crossplane/crossplane/pull/4611)

The workaround, is to have separate Applications for CRs that rely on CRDs created by the `crossplane-init` container. With this approach, second Application will fail to sync and keep retrying while the first Application deploys the CRDs. In this case, we have `crossplane` and `crossplane-providers` Applications. The former creates the `crossplane` Deployment with the `crossplane-init` container which creates the CRDs. The latter creates the `Provider` CRs that rely on the `Provider` CRD from the `crossplane-init` container.

## Provider Credentials
### GCP
https://docs.crossplane.io/latest/getting-started/provider-gcp/#generate-a-gcp-service-account-json-file

Initalize `gcloud`.
```
gcloud init
```

Create a service account, and generate a JSON key for it.
```
export SA_NAME=morey-tech-argocd-crossplane
export PROJECT_ID=akuity-marketing
gcloud iam service-accounts create ${SA_NAME} \
  --description="${SA_NAME} sa" \
  --display-name="${SA_NAME}"
gcloud iam service-accounts keys create ${SA_NAME}.json \
  --iam-account=${SA_NAME}@akuity-marketing.iam.gserviceaccount.com
```

Create a Kubernetes secret with the GCP credentials.
```
kubectl create secret generic gcp-secret \
  -n crossplane-system \
  --from-file=creds=./${SA_NAME}.json
```
