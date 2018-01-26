export KUBECTL_NS=shopify-core

kubessh() {
  if [ -z "$1" ]; then
    >&2 echo "missing pod name"
    return 1
  fi

  POD=$1
  NODE=$(kubectl describe "pods/${POD}" -n "${KUBECTL_NS}" | grep 'Node: ' | awk '{ print $2 }' | cut -d'/' -f1)
  ZONE=$(kubectl describe "nodes/${NODE}" | grep failure-domain.beta.kubernetes.io/zone | cut -d'=' -f2)
  gcloud compute ssh "${NODE}" --zone "${ZONE}"
}

