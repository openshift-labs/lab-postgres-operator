---
Sort: 2
Title: Installing the Operator
---

Before this workshop can be used in an OpenShift cluster, a cluster role and custom resource definitions for the Postgres operator must first be created. The Postgres operator itself is not installed, as that needs to be deployed to each project where it is required. It cannot be installed globally to monitor all projects.

The steps below are not part of what a developer wanting to deploy a Postgres cluster needs to do, and they are not displayed as part of the workshop steps. The steps below will need though to be run once by someone with cluster admin access to the OpenShift cluster.

For original details on installing the Postgres operator, see the documentation at:

* https://crunchydata.github.io/postgres-operator/stable/

Note that the instructions here, and the files used from the Postgres operator package, may have been customised because of how the workshop environment works.

### Login as a cluster admin

The workshop when deployed through the learning portal configuration provides a session using a service account with limited access to a single project. To setup the Postgres operator, you will need to login to the OpenShift cluster as a user with cluster admin access. For RHPDS, this will be the `opentlc-mgr` user.

```execute
oc login
```

### Create a cluster role

The Postgres operator will be deployed to each project where a Postgres cluster is to be created. It will need specific roles to access resources it needs. Create a global cluster role definition. This will later be applied to a service account created in each project, where the Postgres operator runs as that service account.

```execute
oc apply -f - << !
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: pgocrdreader
rules:
  - verbs:
      - get
      - list
      - watch
    apiGroups:
      - '*'
    resources:
      - pgclusters
      - pgbackups
      - pgpolicies
      - pgreplicas
      - pgtasks
      - pgupgrades
---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: pgopclusterrole
rules:
  - verbs:
      - get
      - list
    apiGroups:
      - '*'
    resources:
      - nodes
---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: pgopclusterrolecrd
rules:
  - verbs:
      - '*'
    apiGroups:
      - '*'
    resources:
      - pgclusters
      - pgpolicies
      - pgupgrades
      - pgtasks
      - pgbackups
      - pgreplicas
!
```

### Create custom resource definitions

The Postgres operator is controlled through custom resource definitions (CRDs), but although the operator is deployed in each project it is to be used, the CRDs must be installed globally.

```execute
oc apply -f odev/src/github.com/crunchydata/postgres-operator/deploy/crd.yaml
```

### Grant users Postgres reader rights

The service account a user works through, when a workshop is deployed through the learning portal configuration, will not have any ability to read Postgres CRDs. This is because by default, only cluster admins can work with the required custom resource definitions. In order that a workshop user when using this configuration can read Postgres CRDs, they need to be granted additional cluster roles.

Note they only need read access to CRDs, as they will use the ``pgo`` tool to talk to the operator, which will create a Postgres cluster on their behalf.

Presuming that the workshop is already deployed through the learning portal configuration, and additional cluster policy rules have not been added, run:

```execute
oc patch clusterrole %jupyterhub_application%-%jupyterhub_namespace%-session-rules --patch '
rules:
  - apiGroups:
      - "*"
    resources:
      - pgclusters
      - pgbackups
      - pgpolicies
      - pgreplicas
      - pgtasks
      - pgupgrades
    verbs:
      - get
      - list
      - watch
'
```

### Creation of extra project resources

The Postgres operator needs to be deployed into the project for each user doing the workshop. This needs to be done from the ``.workshop/setup`` script as the Postgres operator installation provides a quite complicated script to do it. It is still though necessary to first set up the service account and RBAC for the project when it is first created by the spawner. To add these run:

```execute
oc patch configmap %jupyterhub_application%-cfg -n %jupyterhub_namespace% --patch '
data:
  extra_resources.json: |-
    {
      "kind": "List",
      "apiVersion": "v1",
      "items": [
        {
          "kind": "ServiceAccount",
          "apiVersion": "v1",
          "metadata": {
            "name": "postgres-operator"
          }
        },
        {
          "kind": "Role",
          "apiVersion": "rbac.authorization.k8s.io/v1beta1",
          "metadata": {
            "name": "pgo-role"
          },
          "rules": [
            {
              "apiGroups": [
                "",
                "cr.client-go.k8s.io"
              ],
              "resources": [
                "pgclusters",
                "pgbackups",
                "pgpolicies",
                "pgreplicas",
                "pgtasks",
                "pgupgrades"
              ],
              "verbs": [
                "get",
                "list",
                "watch"
              ]
            },
            {
              "apiGroups": [
                ""
              ],
              "resources": [
                "pods",
                "services",
                "endpoints",
                "persistentvolumeclaims",
                "events",
                "configmaps",
                "secrets"
              ],
              "verbs": [
                "*"
              ]
            },
            {
              "apiGroups": [
                "apps"
              ],
              "resources": [
                "deployments",
                "daemonsets",
                "replicasets",
                "statefulsets"
              ],
              "verbs": [
                "*"
              ]
            },
            {
              "apiGroups": [
                "batch"
              ],
              "resources": [
                "jobs"
              ],
              "verbs": [
                "*"
              ]
            }
          ]
        },
        {
          "kind": "RoleBinding",
          "apiVersion": "rbac.authorization.k8s.io/v1beta1",
          "metadata": {
            "name": "pgo-role-binding"
          },
          "subjects": [
            {
              "kind": "ServiceAccount",
              "name": "postgres-operator",
              "namespace": "${project_namespace}"
            }
          ],
          "roleRef": {
            "kind": "Role",
            "apiGroup": "rbac.authorization.k8s.io",
            "name": "pgo-role"
          }
        },
        {
          "kind": "ServiceAccount",
          "apiVersion": "v1",
          "metadata": {
            "name": "pgo-backrest"
          }
        },
        {
          "kind": "Role",
          "apiVersion": "rbac.authorization.k8s.io/v1beta1",
          "metadata": {
            "name": "pgo-backrest-role"
          },
          "rules": [
            {
              "apiGroups": [
                ""
              ],
              "resources": [
                "pods"
              ],
              "verbs": [
                "get",
                "list"
              ]
            },
            {
              "apiGroups": [
                ""
              ],
              "resources": [
                "pods/exec"
              ],
              "verbs": [
                "create"
              ]
            }
          ]
        },
        {
          "kind": "RoleBinding",
          "apiVersion": "rbac.authorization.k8s.io/v1beta1",
          "metadata": {
            "name": "pgo-backrest-role-binding"
          },
          "subjects": [
            {
              "kind": "ServiceAccount",
              "name": "pgo-backrest",
              "namespace": "${project_namespace}"
            }
          ],
          "roleRef": {
            "kind": "Role",
            "apiGroup": "rbac.authorization.k8s.io",
            "name": "pgo-backrest-role"
          }
        }
      ]
    }
'
```

XXX Original pgo-role had following, which is granting everything.

```
{
  "apiGroups": [
    "*"
  ],
  "resources": [
    "*"
  ],
  "verbs": [
    "*"
  ]
},
```

As the resources include cluster role bindings, we need to update the policy rules for the spawner cluster role so it can bind those cluster roles against the service account, and add the security context constraints, in the project.

```execute
oc patch clusterrole %jupyterhub_application%-%jupyterhub_namespace%-spawner-rules --patch '
rules:
- apiGroups:
  - ""
  - authorization.openshift.io
  - rbac.authorization.k8s.io
  resourceNames:
  - pgo-role
  - pgo-backrest-role
  resources:
  - clusterroles
  - roles
  verbs:
  - bind
- apiGroups:
  - ""
  resources:
  - configmaps
  - endpoints
  - events
  - persistentvolumeclaims
  - pods
  - secrets
  - services
  verbs:
  - "*"
- apiGroups:
  - "apps"
  resources:
  - daemonsets
  - deployments
  - replicasets
  - statefulsets
  verbs:
  - "*"
- apiGroups:
  - "batch"
  resources:
  - jobs
  verbs:
  - "*"
'
```

### Restarting the workshop spawner

You will now need to restart the learning portal to pick up the new roles. This will cause this workshop session to be killed, so you will need to restart to test the result.

```execute
oc rollout latest %jupyterhub_application% -n %jupyterhub_namespace%
```
