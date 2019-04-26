---
Title: Creating the Cluster
PrevPage: 01-operator-prerequisites
NextPage: 03-creating-the-database
---

Cluster Config:

```exeute-1
export CO_BASEOS=centos7
export CO_VERSION=3.5.2
export CO_IMAGE_TAG=$CO_BASEOS-$CO_VERSION
export CO_IMAGE_PREFIX=crunchydata
export CCP_IMAGE_TAG=$CO_BASEOS-$CO_VERSION
export CCP_IMAGE=crunchy-postgres-gis
export CCP_IMAGE_PREFIX=crunchydata
```

Verify the config settings:

```execute-1
echo "PGO_NAMESPACE is $PGO_NAMESPACE"
echo "CO_IMAGE is $CO_IMAGE"
echo "CO_IMAGE_TAG is $CO_IMAGE_TAG"
echo "CO_IMAGE_PREFIX is $CCP_IMAGE_PREFIX"
echo "CCP_IMAGE is $CCP_IMAGE"
echo "CCP_IMAGE_TAG is $CCP_IMAGE_TAG"
echo "CCP_IMAGE_PREFIX is $CCP_IMAGE_PREFIX"
```

Create the Postgres cluster with one db replica and a pgbackrest repository:

```execute-1

pgo create cluster mycluster --replica-count=2 --pgbackrest -n $PGO_NAMESPACE
```

Check that the CRD for the Postgres cluster has been created:

```execute-1
oc get pgclusters
```

You should see `mycluster` in the output:
```
NAME        AGE                                                                                 
mycluster   4s 
```

```execute-1
pgo show cluster mycluster
```

#### Verify that the Database Service is Running

Confirm that the database creation worked by running the following command to list the available services:

```execute-1
oc get services
```

You should see `mycluster` and `mycluster-replica` in the list of available services:
```
NAME                             TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                                         AGE
mycluster                        ClusterIP   172.30.112.180   <none>        5432/TCP,9100/TCP,10000/TCP,2022/TCP,9187/TCP   2m
mycluster-backrest-shared-repo   ClusterIP   172.30.76.40     <none>        2022/TCP                                        2m 
mycluster-replica                ClusterIP   172.30.68.195    <none>        5432/TCP,9100/TCP,10000/TCP,2022/TCP,9187/TCP   2m
postgres-operator                ClusterIP   172.30.41.114    <none>        8443/TCP                                        3m
```

### List pods associated with the new Postgres cluster
Watch the pod statuses as we wait for the Postgres cluster deployment to complete: 

```execute-2
watch oc get pods
```

Your cluster will be fully available when all three database nodes have reported a status of Ready "1/1":

```
NAME                                 READY     STATUS    RESTARTS   AGE                         
mycluster-6994769cbb-pv9mv           1/1       Running   0          10m                         
mycluster-qlmm-5fff578c74-vhfl9      1/1       Running   0          9m                          
mycluster-vlim-6889f59958-r7rmh      1/1       Running   0          9m                          
postgres-operator-54485967c7-s7ssn   3/3       Running   0          11m
```

After confirming that all three pods in the db cluster are fully available (1/1 Ready), abort the watch command with `CTRL-c` to continue to the next section

```execute-2
<ctrl+c>
```
