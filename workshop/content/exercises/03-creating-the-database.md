---
Title: Creating a Database
PrevPage: 02-creating-the-cluster
NextPage: 04-using-postgres-in-an-app
---

### Retrieve the Password

The administrative credentials can be accessed via the `kubectl get secrets` command.  Try checking the `pgo-auth-secret` secret to find the administrative username and password for this Postgres cluster:

oc get secrets pgo-auth-secret -o 'go-template={{index .data "pgouser"}}' | base64 --decode | head -n 1

Export the admin password for later use:

```
export ADMIN_CREDS=$(oc get secrets pgo-auth-secret -o 'go-template={{index .data "pgouser"}}' | base64 --decode | head -n 1 | cut -f 3 -d:)
echo $ADMIN_CREDS
```

The result should be "pgoadmin"

### Create the Database

1. create a new database usng the pgo tool

Switch back to the *Terminal* tab to find the "primary" db replication pod:

```execute-1
oc get pods -l primary=true | tail -n 1 | cut -f 1 -d' '
```

Remotely execute the `createdb` command on the "primary":

```execute-1
oc exec -it $(oc get pods -l primary=true  | tail -n 1 | cut -f 1 -d' ') createdb etherpad
```

3. Create a dedicated db user and password for the etherpad application to use:

Add an "etherpad" user:

```
pgo create user etherpad --db etherpad --password etherpad --selector=name=mycluster
```

4. Verify read/write access using the "etherpad" user account and db using `psql`:

`sample-db.%project_namespace%.svc.cluster.local` is the hostname for the `sample-db` service. This hostname is only accessible within your OpenShift cluster, but that is sufficient for what you're doing in the lab.

```
export PGO_NAMESPACE=kubectl config view | grep namespace | sed -e 's/.*namespace: \(.*\)$/\1/'
export DB_SVC=mycluster.$PGO_NAMESPACE.svc.cluster.local
psql -h $DB_SVC -U etherpad select * from foo;
```

```
oc exec -it $(oc get pods -l primary=true  | tail -n 1 | cut -f 1 -d' ') psql -- -U etherpad
etherpad=> CREATE TABLE foo (name character varying(240), done bool);
```

The output should be:
```
CREATE TABLE                                                                                                             ```

Confirm that the table has been created:
```
etherpad=> select * from foo;
```

output:

```

 name | done                                                                                                                        
------+------                                                                                                                       
(0 rows)                                               
```

Insert some test data into table `foo`:
```
etherpad=> insert into foo values ('Ryan J', true);
```

expected response:
```
INSERT 0 1                                                                                                               ```

Verify that the new table row has been persisted:
```
etherpad=> select * from foo;
```

Output:

```                                                                                         
  name  | done                                                                                                                      
--------+------                                                                                                                     
 Ryan J | t                                                                                                                         
(1 row)      

```

Exit the sql session to return to the command prompt:

```execute-1
\q
```

Now that you've confirmed that your database is working via the `psql` command-line tool, we'll configure a front-end application to take advantage of the datastore.

5. create a snapshot of the db (w/ etherpad database and access credentials)


Users can create a pgBackRest backup using the following pgo CLI command:

```execute-1
pgo backup mycluster --backup-type=pgbackrest
```
