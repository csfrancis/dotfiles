export KUBECONFIG=~/.kube/config
export KUBECTL_NS=shopify-core

kubessh() {
  if [ -z "$1" ]; then
    >&2 echo "missing pod name"
    return 1
  fi

  if [[ "$(kubectl get pods "$1" -n "${KUBECTL_NS}" 2>&1 || true)" == Error* ]]; then
    POD=$(kubectl get pods --selector="app=${1}" -n "${KUBECTL_NS}" | grep ' Running ' | awk '{print $1}')
    if [ -z "${POD}" ]; then
      return 1
    fi
  else
    POD=$1
  fi

  NODE=$(kubectl describe "pods/${POD}" -n "${KUBECTL_NS}" | grep 'Node: ' | awk '{ print $2 }' | cut -d'/' -f1)
  ZONE=$(kubectl describe "nodes/${NODE}" | grep failure-domain.beta.kubernetes.io/zone | cut -d'=' -f2)
  gcloud compute ssh "${NODE}" --zone "${ZONE}"
}

