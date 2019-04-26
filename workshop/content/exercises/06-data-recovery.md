---
Title: Snapshot Automation and Data Recovery
PrevPage: 05-high-availability
NextPage: ../final
---

The PostgreSQL Operator 3.5 provides point-in-time-recovery from this newly introduced pgBackRest shared repository by implementing the pgBackRest restore command.

Recovering from data loss: 

Find a specific point in time to roll back to (in order to recover from data loss):

```execute-1
export PITR=$(psql -h $DB_SVC -U etherpad etherpad -c 'select now()' | head -n 3 | tail -n 1 | cut -f 2,3 -d' ')
echo $PITR
```

```execute-1
etherpad
```

1. log in to the primary and drop the DB (password: etherpad):
```execute-1
psql -h $DB_SVC -U etherpad etherpad -c 'drop table foo;'
```

```execute-1
etherpad
```

2. verify that we are no longer able to find table `foo`:
```execute-1
psql -h $DB_SVC -U etherpad etherpad -c 'select * from foo;'
```

```execute-1
etherpad
```

3. show list backups command
Users can view pgBackRest backups using the following command:

```
pgo show backup mycluster --backup-type=pgbackrest
```

4. show restore snapshot command
Users can perform a point-in-time restore of a given cluster with pgBackRest using the following command:

```
pgo restore mycluster --backup-opts="--type=time" --pitr-target="$PITR"
```

5. verify that our data has been restored

```execute-1
psql -h $DB_SVC -U etherpad etherpad -c 'select * from foo;'
```

```execute-1
etherpad
```

Visit the etherpad web service to confirm that data has been successfully recovered

more on this topic:
https://info.crunchydata.com/blog/pgbackrest-point-in-time-recovery-using-crunchy-postgresql-operator

## Summary

Now that you've completed this lab, you should be familiar with:
* How to create a Postgres Enterprise cluster using the Crunchy Enterprise Postgres operator
* How to create a Postgres database using the `pgo` command-line tool, and how to store and retrieve data using basic SQL statements
* How to connect our Etherpad example application to the Postgres datastore
* The basics of how the Cunchy PostgreSQL operator handles snapshots and data recovery for the cluster

Continue to the next page for more resources on OpenShift, Operators, and Postgres.
