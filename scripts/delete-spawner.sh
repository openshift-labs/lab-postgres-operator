#!/bin/bash

set -x
set -eo pipefail

JUPYTERHUB_APPLICATION=${JUPYTERHUB_APPLICATION:-postgres-lab}
JUPYTERHUB_NAMESPACE=`oc project --short`

PROJECT_RESOURCES="services,routes,deploymentconfigs,secrets,configmaps,serviceaccounts,rolebindings,serviceaccounts,rolebindings,persistentvolumeclaims"

oc delete "$PROJECT_RESOURCES" \
    --selector app="$JUPYTERHUB_APPLICATION"

CLUSTER_RESOURCES="clusterrolebindings,clusterroles"

oc delete "$CLUSTER_RESOURCES" \
    --selector app="$JUPYTERHUB_APPLICATION-$JUPYTERHUB_NAMESPACE"
