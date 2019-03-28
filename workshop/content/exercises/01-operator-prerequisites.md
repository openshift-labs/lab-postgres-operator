---
Title: Operator Prerequisites
PrevPage: ../index
NextPage: 02-creating-the-cluster
---

The Postgres operator is installed into a project to monitor requests to create a Postgres cluster. The operator can only be deployed and setup by a cluster admin of the OpenShift cluster.

In this workshop environment, the Postgres operator has been pre-installed into your project ready for use. The user you are running the workshop as, has also been delegated the appropriate roles to allow it to create a Postgres cluster.

To validate that your user has been granted the appropriate roles, you can use the `oc auth can-i` command to see whether you can create the custom resource definition (CRD) objects the Postgres operator responds to.

The CRD object you need to create to request the creation of a Postgres cluster is the `postgrescluster` object in the `postgres.com` api group. To check that you can create this, run:

```execute
oc auth can-i create postgresclusters.postgres.com
```

Where the response is `yes`, you have the appropriate role access.

We also need to verify that the Postgres operator has been deployed into your project. To check this, run:

```execute
pgo version
```

You should see a message giving the version of the `pgo` client and Postgres operator.
