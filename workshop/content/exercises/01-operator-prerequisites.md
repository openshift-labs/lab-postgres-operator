---
Title: Operator Prerequisites
PrevPage: ../index
NextPage: 02-creating-the-cluster
---

Installation and setup steps are available for vanilla K8s:
https://operatorhub.io/operator/alpha/postgres-operator.v3.5.0

screenshot of above

Since we're using OpenShift, the OperatorLifecycleManager (OLM), and a collection of Operator-based solutions have been bundled as stock compoents in this distribution of Kubernetes.

screenshot of install modal dialog

The Postgres operator is installed into a project to monitor requests to create a Postgres cluster. The operator can only be deployed and setup by a cluster admin of the OpenShift cluster.

In this workshop environment, the Postgres operator has been pre-installed into your project ready for use. The user you are running the workshop as, has also been granted the appropriate access to create a Postgres cluster.

To validate that your user has been granted the appropriate access, you can use the `oc auth can-i` command to see whether you can list the custom resource definition (CRD) objects the Postgres operator uses.

The main CRD object that the Postgres operator uses is the `pgclusters` object. To check that you can view these, run:

```execute
oc auth can-i get pgclusters
```

Where the response is `yes`, you have the appropriate role access.

Next verify that the Postgres operator has been deployed into your project. To check this, run:

```execute-1
oc rollout status deployment/postgres-operator
```

You should see a message:

```
deployment "postgres-operator" successfully rolled out
```

If the deployment hasn't yet completed, you will see progress messages as it starts up. Wait for the deployment to finish before proceeding.

Finally, verify that the Postgres operator API server os responding. To check this, run:

```execute
pgo version
```

You should see a message giving the version of the `pgo` client and Postgres operator API server. It is the `pgo` command that you will use to interact with the Postgres operator to create and manage Postgres clusters.
