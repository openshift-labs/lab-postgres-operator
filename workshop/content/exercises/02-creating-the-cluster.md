---
Title: Creating the Cluster
PrevPage: 01-operator-prerequisites
NextPage: 03-creating-the-database
---

Create the Postgres cluster with two database replica:

```execute-1
pgo create cluster mycluster --replica-count=2
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

To show details of the cluster run:

```execute-1
pgo show cluster mycluster
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
