---
Title: Creating the Cluster
PrevPage: 01-operator-prerequisites
NextPage: ../finish
---

Set up a watch of pods created for the Postgres cluster.

```execute-2
oc get pods --watch
```

Create the Postgres cluster.

```execute-1
pgo create cluster mycluster --replica-count=2
```

Check that the CRD for the Postgres cluster has been created

```execute-1
oc get pgclusters
```

Wait for the Postgres cluster to be deployed, then kill the watch.

```execute-2
<ctrl+c>
```
