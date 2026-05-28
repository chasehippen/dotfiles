# Quick Commands

A personal reference of frequently used commands for Teleport, Kubernetes, AWS, Crossplane, Istio, ArgoCD, Terraform, Go, and MongoDB.

> ⚠️ **Note:** All credentials, account IDs, tenant names, and hostnames in this document are placeholders. Replace values like `REDACTED`, `<your-org>`, `<your-domain>`, `<role-name>`, etc. with values appropriate to your environment — never commit real secrets.

---

## Table of Contents

- [Teleport](#teleport)
- [Crossplane](#crossplane)
- [Filesystem](#filesystem)
- [AWS](#aws)
- [GitHub Code Search](#github-code-search)
- [Kubernetes](#kubernetes)
  - [General](#general)
  - [Nodes & Node Groups](#nodes--node-groups)
  - [Secrets](#secrets)
  - [Debugging](#debugging)
  - [Admission Controllers](#admission-controllers)
  - [`kubectl run` cheatsheet](#kubectl-run-cheatsheet)
  - [`kubectl exec` cheatsheet](#kubectl-exec-cheatsheet)
- [ArgoCD](#argocd)
- [Istio](#istio)
- [MongoDB](#mongodb)
- [Kafka Connect (kcctl)](#kafka-connect-kcctl)
- [Go](#go)
- [Terraform](#terraform)

---

## Teleport

### Remove a role from all users

```bash
ROLE=<role-name>

tctl get users --format=json \
  | jq -r --arg ROLE "$ROLE" '
      .[]
      | select((.spec.roles // []) | index($ROLE))
      | .metadata.name
    ' \
  | while IFS= read -r u; do
      echo "Removing $ROLE from $u"

      tctl get "user/$u" --format=json \
        | jq --arg ROLE "$ROLE" '
            # unwrap 1-element arrays that some tctl versions return
            (if type=="array" then .[0] else . end)
            | .spec.roles |= map(select(. != $ROLE))
          ' \
        | tctl create -f -
    done
```

---

## Crossplane

### List all broken Crossplane composite resources for a given API group

```bash
API_GROUP=<your.api.group>

kubectl get compositeresourcedefinitions.apiextensions.crossplane.io \
  -o jsonpath="{range .items[?(@.spec.group==\"$API_GROUP\")]}{.spec.names.plural}.{.spec.group}{\"\n\"}{end}" \
  | xargs -n1 kubectl get \
  | ag "False"
```

---

## Filesystem

### Find all relevant source files and copy contents to clipboard

Excludes git, vendored files, examples, tests, terraform state, and binary artifacts.

```bash
find . \
  -path '*/.git' -prune -o \
  -path '*/values.yaml' -prune -o \
  -path '*example*' -prune -o \
  -path '*test*' -prune -o \
  -path '*/.terraform*' -prune -o \
  -type f ! \( \
    -name '*.tgz' -o \
    -name '*.tar.gz' -o \
    -name '*.zip' -o \
    -name 'go.mod' -o \
    -name 'go.sum' -o \
    -name '*.md' -o \
    -name 'README.md.gotmpl' -o \
    -name '.helmignore' \
  \) -print0 \
  | while IFS= read -r -d '' file; do
      printf "\n===== %s =====\n" "$file"
      cat "$file"
    done \
  | pbcopy
```

---

## AWS

### Find a secret in Secrets Manager containing a given value

```bash
VALUE="your-search-string"

for secret_arn in $(aws secretsmanager list-secrets --query 'SecretList[*].ARN' --output text); do
  secret_value=$(aws secretsmanager get-secret-value --secret-id "$secret_arn" --query 'SecretString' --output text)
  if echo "$secret_value" | ag "$VALUE"; then
    echo "Found secret with value in: $secret_arn"
  fi
done
```

---

## GitHub Code Search

### Find every call site of a Terraform module

```text
org:<your-org> path:*.tf NOT is:archived /module\s+"[^"]+"\s*\{?(?:[^\n]*\n){0,5}[^\n]*source\s*=\s*"[^"\n]*$MODULE_NAME"/
```

---

## Kubernetes

### General

#### Find all pods using a container image matching a name

```bash
IMAGE_MATCH=nginx

kubectl get pods --all-namespaces \
  -o jsonpath="{range .items[*]}{'pod: '}{.metadata.name}{'\tnode: '}{.spec.nodeName}{'\timages: '}{range .spec['initContainers', 'containers'][*]}{.image}{', '}{end}{'\n'}{end}" \
  | ag "$IMAGE_MATCH"
```

#### Get all ExternalSecrets across multiple environments

Assumes your kube context switches based on a `$K8S_ENV` variable (adapt to your tooling).

```bash
for env in dev sit staging prod; do
  echo "===== $env =====" >> outputs.txt
  K8S_ENV=$env kubectl get externalsecrets.kubernetes-client.io -A >> outputs.txt
done
```

#### List every resource type and grep across the entire cluster

```bash
SEARCH=<search-term>

kubectl api-resources --verbs=list -o name | while read -r resource; do
  kubectl get "$resource" --all-namespaces \
    -o custom-columns="KIND:$resource,NAMESPACE:.metadata.namespace,NAME:.metadata.name" 2>/dev/null \
    | ag -i "$SEARCH"
done
```

#### Watch for pods with fewer ready containers than total (excluding `Completed`)

```bash
watch "kubectl get pod -A | awk 'NR == 1 || (split(\$3, a, \"/\") && a[1] < a[2] && \$4 != \"Completed\")'"
```

---

### Nodes & Node Groups

#### Get AMI name of all nodes (EKS)

```bash
kubectl get nodes -o json | jq -r '
  .items[] | [
    .metadata.labels."eks.amazonaws.com/nodegroup",
    .metadata.name,
    (.spec.providerID | split("/") | .[-1]),
    .status.nodeInfo.kubeletVersion,
    .metadata.creationTimestamp,
    (.status.conditions[] | select(.type=="Ready") | .status),
    (.spec.unschedulable // ""),
    (.spec.providerID | split("/") | .[3] | sub("[a-z]$"; ""))
  ] | @tsv
' | while IFS=$'\t' read -r NODE_POOL NAME INSTANCE_ID VERSION CREATED READY UNSCHEDULABLE REGION; do
  REGION=${REGION:-us-west-2}
  AMI_ID=$(aws ec2 describe-instances --instance-ids "$INSTANCE_ID" --region "$REGION" \
    --query "Reservations[0].Instances[0].ImageId" --output text)
  AMI_NAME=$(aws ec2 describe-images --image-ids "$AMI_ID" --region "$REGION" \
    --query "Images[0].Name" --output text)
  echo "$NODE_POOL $NAME $INSTANCE_ID $VERSION $CREATED $READY $UNSCHEDULABLE $REGION $AMI_NAME"
done | column -t
```

#### Get the node group each pod in a namespace is scheduled on

```bash
namespace=<namespace>

kubectl get pods -n "$namespace" \
  -o=custom-columns=NAME:.metadata.name,NODE:.spec.nodeName,NODE_GROUP:.spec.nodeName \
  --no-headers=true \
  | awk '{ print $1, $3 }' \
  | while read -r pod node; do
      label=$(kubectl get node "$node" -o=jsonpath="{.metadata.labels['eks\.amazonaws\.com/nodegroup']}")
      printf "%-35s %-35s\n" "$pod" "$label"
    done
```

#### Watch node groups with node pool, instance ID, version, and region

```bash
watch "kubectl get node -o custom-columns='NODE_POOL:metadata.labels.eks\.amazonaws\.com\/nodegroup,NAME:.metadata.name,INSTANCE_ID:.spec.providerID,VERSION:.status.nodeInfo.kubeletVersion,CREATED:.metadata.creationTimestamp,READY:.status.conditions[?(@.type==\"Ready\")].status,UNSCHEDULABLE:.spec.unschedulable' \
  | awk -F'/' '{print \$1,\$2,\$5,\$3,\$4,\$6,\$7,\$4}' \
  | sed 's/aws://g' \
  | awk 'NR==1{print \"NODE_POOL NAME INSTANCE_ID VERSION CREATED READY UNSCHEDULABLE REGION\"};NR>1{print \$1,\$2,\$3,\$4,\$5,\$6,\$7,substr(\$8,1,length(\$8)-1)}' \
  | sort -k5 -r \
  | column -t"
```

---

### Secrets

#### Get a secret and decode all values

```bash
SECRET=<secret-name>

kubectl get secret/"$SECRET" -o jsonpath="{.data}" | jq '. | map_values(@base64d)'
```

Or for a single key (e.g. a docker config):

```bash
kubectl get secret/<secret-name> -o jsonpath="{.data.\.dockerconfigjson}" | base64 --decode | jq
```

---

### Debugging

#### Run an interactive debug pod

```bash
kubectl run -i --tty --rm debug --image=ubuntu -- bash
```

---

### Admission Controllers

#### List all validating admission webhooks

```bash
kubectl get --raw /apis/admissionregistration.k8s.io/v1/validatingwebhookconfigurations \
  | jq '.items[].webhooks[].name'
```

---

### `kubectl run` cheatsheet

Basic structure:

```bash
kubectl run [NAME] --image=[IMAGE] [options]
```

| Use case | Command |
| --- | --- |
| Run a pod | `kubectl run my-pod --image=nginx` |
| Expose a port | `kubectl run my-pod --image=nginx --port=80` |
| Interactive debug pod | `kubectl run -i --tty debug --image=busybox -- sh` |
| Detached pod | `kubectl run my-pod --image=nginx --detach` |
| With env vars | `kubectl run my-pod --image=nginx --env="NAME=value" --env="ANOTHER=value"` |
| Run a command | `kubectl run my-pod --image=busybox --command -- echo "Hello, Kubernetes!"` |
| Resource requests | `kubectl run my-pod --image=nginx --requests='cpu=100m,memory=256Mi'` |
| Resource limits | `kubectl run my-pod --image=nginx --limits='cpu=200m,memory=512Mi'` |
| Labels | `kubectl run my-pod --image=nginx --labels="key1=value1,key2=value2"` |
| Annotations | `kubectl run my-pod --image=nginx --annotations="key1='value1',key2='value2'"` |
| Dry-run to YAML | `kubectl run my-deployment --image=nginx --dry-run=client -o yaml > my-deployment.yaml` |

---

### `kubectl exec` cheatsheet

Basic structure:

```bash
kubectl exec [POD_NAME] -- [COMMAND]
```

| Use case | Command |
| --- | --- |
| Exec in default container | `kubectl exec my-pod -- ls /` |
| Exec in a specific container | `kubectl exec my-pod -c my-container -- ls /` |
| Interactive bash | `kubectl exec -it my-pod -- /bin/bash` |
| Interactive sh in container | `kubectl exec -it my-pod -c my-container -- /bin/sh` |
| Exec in a namespace | `kubectl exec my-pod --namespace=my-namespace -- ls /` |

Copy files (uses `kubectl cp`, not `exec`):

```bash
# Local → pod
kubectl cp /path/to/local/file my-pod:/path/to/remote/file

# Pod → local
kubectl cp my-pod:/path/to/remote/file /path/to/local/file
```

Find a pod by label, then exec into it:

```bash
kubectl get pods -l app=my-app
kubectl exec -it <pod-from-above> -- /bin/bash
```

---

## ArgoCD

### Rollout-restart every deployment and statefulset in the ArgoCD namespace

```bash
NS=<argocd-namespace>

kubectl get deployment  -n "$NS" | awk '{print $1}' | ag -v "NAME" | xargs kubectl rollout restart deployment  -n "$NS"
kubectl get statefulset -n "$NS" | awk '{print $1}' | ag -v "NAME" | xargs kubectl rollout restart statefulset -n "$NS"
```

---

## Istio

### Enable JSON access logs

Set on the `istio` ConfigMap in `istio-system`:

```yaml
accessLogEncoding: JSON
accessLogFile: /dev/stdout
```

### Tail and filter ingress gateway access logs with `jq`

```bash
HOST=<your.host.example.com>

kubectl logs -n istio-system -l istio=ingressgateway-alb -f \
  | jq --arg host "$HOST" '
      select(.authority == $host)
      | to_entries | sort_by(.key) | from_entries
      | {authority, method, path, protocol, response_code, response_code_details, upstream_cluster, user_agent}
    '
```

### Inspect listeners for a gateway pod on port 8080

```bash
GW_POD=<ingress-gateway-pod>
NS=<gateway-namespace>

istioctl pc listeners -n "$NS" "$GW_POD" --address 0.0.0.0 --port 8080 -o yaml \
  | yq '.[] |
      {"name": .name} +
      {"address": .address} +
      {"trafficDirection": .trafficDirection} +
      {"filterChains": [
        .filterChains[] |
        {
          "filterChainMatch": .filterChainMatch,
          "http_connection_manager": (
            .filters[]
            | select(.name == "envoy.filters.network.http_connection_manager")
            | {
                "httpFilters": (
                  .typedConfig.httpFilters
                  | map(select(
                      .name == "envoy.filters.http.grpc_stats"
                      or .name == "istio.alpn"
                      or .name == "envoy.filters.http.router"
                  ))
                )
              }
          )
        }
      ]}'
```

### List virtual hosts and clusters they route to

```bash
GW_POD=<ingress-gateway-pod>
DOMAIN_MATCH=<substring-of-domain>

istioctl pc route -n istio-system "$GW_POD" -o json \
  | jq -r --arg match "$DOMAIN_MATCH" '
      .[]
      | .virtualHosts[]
      | select(any(.domains[]; contains($match)))
      | {name: .name, clusters: [.routes[].route.cluster]}
    '
```

### Show typed protocol options for a specific upstream cluster

```bash
GW_POD=<ingress-gateway-pod>
CLUSTER_MATCH=<cluster-fqdn-substring>   # e.g. my-service.my-namespace.svc.cluster.local

istioctl pc clusters -n istio-system "$GW_POD" -o yaml \
  | yq eval ".[]
      | select(.name | contains(\"$CLUSTER_MATCH\"))
      | {\"name\": .name, \"typedExtensionProtocolOptions\": .typedExtensionProtocolOptions}" -
```

---

## MongoDB

Connect with `mongosh`:

```bash
mongosh "mongodb+srv://<user>:<password>@<cluster-host>/<database>?retryWrites=true&w=majority"
```

---

## Kafka Connect (kcctl)

Set contexts for each environment. Pull credentials from your secret store; never paste them inline.

```bash
kcctl config set-context <env-name> \
  --cluster  https://<connect-host> \
  --username <user> \
  --password "REDACTED"
```

---

## Go

### Format, tidy, test, and generate coverage report

```bash
go fmt ./... \
  && go clean -modcache \
  && go mod tidy \
  && go install github.com/axw/gocov/gocov@latest \
  && go install github.com/AlekSi/gocov-xml@latest \
  && go test -coverprofile=cover.out ./... \
  && go tool cover -html=cover.out
```

### Run integration tests without noisy Terraform output

```bash
SKIP_cleanup=true go test -v -count=1 -timeout 90m | ag -v "Still creating|Refreshing state"
```

---

## Terraform

### Import a resource

Replace every `REDACTED` with a value sourced from your secret manager — **do not commit real credentials**. The variable list below is illustrative; adjust to match your root module.

```bash
TF_LOG=DEBUG terraform import \
  -var "GITHUB_TOKEN=REDACTED" \
  -var "github_app_id=REDACTED" \
  -var "github_app_installation_id=REDACTED" \
  -var "github_app_pem_file=REDACTED" \
  -var "ARGOCD_AUTH_USERNAME=REDACTED" \
  -var "ARGOCD_AUTH_PASSWORD=REDACTED" \
  -var "ARGOCD_SERVER_ADDRESS=REDACTED" \
  -var "circleci_api_key=REDACTED" \
  -var "codeclimate_api_key=REDACTED" \
  -var "datadog_api_key=REDACTED" \
  -var "datadog_app_key=REDACTED" \
  -var "HCP_CLIENT_ID=REDACTED" \
  -var "HCP_CLIENT_SECRET=REDACTED" \
  -var "snyk_token=REDACTED" \
  -var "teleport_identity_file_base64=REDACTED" \
  -var "tfe_token=REDACTED" \
  '<terraform.address>' \
  '<import-id>'
```
