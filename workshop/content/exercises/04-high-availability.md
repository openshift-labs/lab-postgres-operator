---
Title: High-Availability
PrevPage: 03-creating-the-database
NextPage: 05-using-postgres-in-an-app
---

Now that your Postgres cluster is running and you've created a database, let's explore the auto-recovery behavior and see what happens if one of the nodes in the cluster fails.

```execute-2
watch oc get pods
```

### Scaling

Observe how the cluster responds to each of the following commands as we test various high-availability features that are provided by this operator.

First, let's try adding an extra replica, to increase our ability to scale reads:

```execute-1
pgo scale mycluster --replica-count=1 --no-prompt
```

### Auto Recovery

Simulate the failure and autorecovery of a DB replica:

```execute-1
oc delete pod $(oc get pods -l primary=false | tail -n 1 | cut -f 1 -d' ')
```

Simulate the failure and autorecovery of a Primary DB node:

```execute-1
oc delete pod $(oc get pods -l primary=true | tail -n 1 | cut -f 1 -d' ')
```

### Read-Only Replicas

Contact a replica to verify that our data is still available:

```execute-1
psql -h $DB_REPLICA_SVC -U etherpad etherpad -c 'select * from foo;'
```

If you see the following data available on the replicas, then your writes have been successfully duplicated:
```
  name  | done                                                                                                                 
--------+------                                                                                                                
 Ryan J | t                                                                                                                    
(1 row)
```

Attempt to drop the db table while connected to a read-only replica:

```execute-1
psql -h $DB_REPLICA_SVC -U etherpad etherpad -c 'drop table foo;'
```

Expected:

```
ERROR:  cannot execute DROP TABLE in a read-only transaction
```

### Replication Validation

Attempt to drop the table while connected to a read/write primary:

```execute-1
psql -h $DB_SVC -U etherpad etherpad -c 'drop table foo;'
```

Expected: the `drop table` command should succeed on the read/write primary

And the `drop table` transaction should be replicated throughout the cluster:

Query one of the db replicas to confirm that the `drop table` transaction has been replicated throughout the cluster:

```execute-1
psql -h $DB_REPLICA_SVC -U etherpad etherpad -c 'select * from foo;'
```

Expected response:

```
ERROR:  relation "foo" does not exist
LINE 1: select * from foo;
                      ^
```

This should prove that despite both of our simulated outages, db replicantion is still working as expected.  And, writes are only allowed when connected to the primary db service endpoint.

### Manual Failovers

To lean about manually triggering a failover using `pgo` try running:

```execute-1
pgo failover --help
```

Specific failover targets for this cluster should be visible in the output here:

```execute-1
pgo failover mycluster --query
```

### Upgrade Automation

For information about migrating/upgrading your db cluster to a newer release, try running the following:

```execute-1
pgo upgrade --help
```

## Summary

Now that you've completed this section, you should be familiar with:
* How to create a Postgres cluster using the `pgo` command-line tool and the Crunchy Enterprise Postgres operator
* How to create Postgres databases, and user access controls
* How to verify read/write access to our db using the psql command-line tool
* How to verify that data replication is working correctly
* How to test the auto-recovery features of a Crunchy Enterprise Postgres cluster

In the next section, we'll configure a front-end application to communicate with the datastore.
