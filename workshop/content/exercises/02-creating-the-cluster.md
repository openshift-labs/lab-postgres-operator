---
Title: Creating the Cluster
PrevPage: 01-operator-prerequisites
NextPage: 03-creating-the-database
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

You should see one cluster in the output:
```execute-1
mycluster <output needed>
```

#### Verify that the Database Service is Running

Confirm that the database creation worked by running the following command to list the available services:

```execute-2
oc get services
```

You should see `mycluster` and `mycluster-replica` in the list of available services:
```
NAME                TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                                         AGE
mycluster           ClusterIP   172.30.112.180   <none>        5432/TCP,9100/TCP,10000/TCP,2022/TCP,9187/TCP   2m
mycluster-replica   ClusterIP   172.30.68.195    <none>        5432/TCP,9100/TCP,10000/TCP,2022/TCP,9187/TCP   2m
postgres-operator   ClusterIP   172.30.41.114    <none>        8443/TCP        


#### export your namespace

Export the current namespace using the `PGO_NAMESPACE` env var:
```execute-1
export PGO_NAMESPACE=kubectl config view | grep namespace | sed -e 's/ *namespace: \(.*\)$/\1/' 
```


Wait for the Postgres cluster to be deployed. After each of the three database nodes have reported a status of 1/1 available, your database should be fully available. 

After confirming that the cluster is available, abort the watch command with `CTRL-c` when you're ready to continue on to the next section

```execute-2
<ctrl+c>
```
