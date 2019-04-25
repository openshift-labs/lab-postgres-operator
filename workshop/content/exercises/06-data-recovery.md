---
Title: Snapshot Automation and Data Recovery
PrevPage: 05-high-availability
NextPage: ../final
---

The PostgreSQL Operator 3.5 provides point-in-time-recovery from this newly introduced pgBackRest shared repository by implementing the pgBackRest restore command.

//Users can create a pgBackRest backup using the following pgo CLI command:
//
//pgo backup mycluster --backup-type=pgbackrest

Recovering from data loss: 

1. log in to the primary and drop the DB
```execute-1
oc exec -it $(oc get pods -l primary=true  | tail -n 1 | cut -f 1 -d' ') psql -- -U etherpad 'drop database etherpad;'
```

2. verify that we have data loss and an ongoing outage:
```execute-1
oc exec -it $(oc get pods -l primary=true  | tail -n 1 | cut -f 1 -d' ') psql -- -U etherpad 'select * from foo;'
```

3. show list backups command
Users can view pgBackRest backups using the following command:

```
pgo show backup mycluster --backup-type=pgbackrest
```

4. show restore snapshot command
Users can perform a point-in-time restore of a given cluster with pgBackRest using the following command:

```
pgo restore mycluster --backup-opts="--type=time" --pitr-target="2019-01-14 00:02:14.921404+00"
```

Note: When you restore a cluster, you are putting your PostgreSQL database into a different state (or timeline) and therefore you should exercise caution before doing so!

5. verify that our data has been restored

```execute-1
oc exec -it $(oc get pods -l primary=true  | tail -n 1 | cut -f 1 -d' ') psql -- -U etherpad 'select * from foo;'
```

Visit the etherpad web service to confirm that data has been successfully recovered

more on this topic:
https://info.crunchydata.com/blog/pgbackrest-point-in-time-recovery-using-crunchy-postgresql-operator


### pgo-scheduler

New in PostgreSQL Operator 3.5: a dedicated cron scheduler now runs within the Operator pod. This scheduler is tightly integrated into the Operator and offers users a means to schedule pg_basebackup, pgBackRest, and policy scheduled jobs (or in other words, jobs where you want to run your own SQL). Users interact with the scheduler using the following commands:

pgo create schedule
pgo delete schedule
pgo show schedule


## Summary

Now that you've completed this lab, you should be familiar with:
* How to create a Postgres Enterprise cluster using the Crunchy Enterprise Postgres operator
* How to create a Postgres database using the `pgo` command-line tool, and how to store and retrieve data using basic SQL statements
* How to connect our Etherpad example application to the Postgres datastore
* The basics of how the Cunchy PostgreSQL operator handles snapshots and data recovery for the cluster

Continue to the next page for more resources on OpenShift, Operators, and Postgres.
