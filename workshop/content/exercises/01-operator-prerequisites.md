---
Title: Operator Prerequisites
PrevPage: ../index
NextPage: 02-creating-the-cluster
---

The Postgres operator is installed into a project to monitor requests to create a Postgres cluster. The operator can only be deployed and setup by a cluster admin of the OpenShift cluster.

In this workshop environment, the Postgres operator has been pre-installed into your project ready for use. The user you are running the workshop as, has also been granted the appropriate access to create a Postgres cluster.

To validate that your user has been granted the appropriate access, you can use the `oc auth can-i` command to see whether you can list the custom resource definition (CRD) objects the Postgres operator uses.

The main CRD object that the Postgres operator uses is the `pgclusters` object. To check that you can view these, run:

```execute
oc auth can-i get pgclusters
```

Where the response is `yes`, you have the appropriate role access.

We also need to verify that the Postgres operator has been deployed into your project. To check this, run:

```execute
pgo version
```

You should see a message giving the version of the `pgo` client and Postgres operator API server. It is the `pgo` command that you will use to interact with the Postgres operator to create and manage Postgres clusters.
