#!/bin/bash
set -e

#SERVER=""
#TOKEN=""
#NAMESPACE=""
#ACTION=create
#SESSION=
#DEPLOYMENT=
#ROUTE=
#IMAGE=

TMP_DIR=$(mktemp -d)
KUBE_CONFIG_FILE="$TMP_DIR/kube.yaml"

KUBE_CONFIG_TMPL="kind: Config
apiVersion: v1
preferences: {}
current-context: cli
clusters:
- cluster:
    server: ::SERVER::
    insecure-skip-tls-verify: true
  name: cluster
contexts:
- context:
    cluster: cluster
    user: user
  name: cli
users:
- name: user
  user:
    token: ::TOKEN::
"

# Remap env IKE_PORT to IKE_ACTION_PORT for simplicity
ACTION_ENV=IKE_${ACTION^^}_
for var in $(set | grep IKE_ | grep -v ACTION_ENV)
do
  #echo "Remapping variable: ${var/IKE_/$ACTION_ENV}"
  export "${var/IKE_/$ACTION_ENV}"
done
#echo "Writing kube config file: $KUBE_CONFIG_FILE"
KUBE_CONFIG_CONTENT=$(echo "$KUBE_CONFIG_TMPL" | sed "s|::SERVER::|$SERVER|g" | sed "s|::TOKEN::|$TOKEN|g")
echo "$KUBE_CONFIG_CONTENT" > $KUBE_CONFIG_FILE

#echo "Launching ike"
export KUBECONFIG=$KUBE_CONFIG_FILE
exec ike $ACTION
