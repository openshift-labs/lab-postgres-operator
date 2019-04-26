---
Title: High-Availability
PrevPage: 03-creating-the-database
NextPage: 05-using-postgres-in-an-app
---
Now that your Postgres cluster is running and you've created a database, let's explore the auto-recovery behavior and see what happens if one of the nodes in the cluster fails.

```execute-2
oc get pods --watch
```

Add an extra replica, to increase our ability to scale reads:

```execute-1
pgo scale mycluster --replica-count=1
```

1. Simulate failure and autorecovery of a Primary DB node:

```execute-1
kubectl delete pod $(kubectl get pods -l primary=true | tail -n 1 | cut -f 1 -d' ')
```

2. Simulate failure and autorecovery of a DB replica:

```execute-1
kubectl delete pod $(kubectl get pods -l primary=false | tail -n 1 | cut -f 1 -d' ')
```

3. contact a replica to prove that our data is still available:

```execute-1
psql -h $DB_REPLICA_SVC -U etherpad etherpad -c 'select * from foo;'
```

4. attempt to drop the table while connected to a read-only replica:

```execute-1
psql -h $DB_REPLICA_SVC -U etherpad etherpad -c 'drop table foo;'
```

Expected: write access denied on read-only replica

```execute-1
psql -h $DB_SVC -U etherpad etherpad -c 'drop table foo;'
```

Expected: the `drop table` command should succeed on the read/write primary

And the `drop table` transaction should be replicated throughout the cluster:

```execute-1
psql -h $DB_REPLICA_SVC -U etherpad etherpad -c 'select * from foo;'
```

Expected: no table found

### cluster failover

show failover command

### cluster upgrade automation

show example command


Follow up: 

Guide to building an active-active cluster:
https://info.crunchydata.com/blog/a-guide-to-building-an-active-active-postgresql-cluster

Now that you've completed this scenario, you should be familiar with:
* How to create a Postgres cluster using the `pgo` command-line tool and the Crunchy Enterprise Postgres operator
* How to create Postgres databases, and user access controls
* How to verify read/write access to our db using the psql command-line tool
* How to verify that data replication is working correctly
* How to test the auto-recovery features of a Crunchy Postgres cluster

In the next section, we'll configure a front-end application to communicate with the datastore.
