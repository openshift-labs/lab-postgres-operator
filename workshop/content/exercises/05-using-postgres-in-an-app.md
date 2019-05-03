---
Title: Using Postgres in an Application
PrevPage: 04-high-availability
NextPage: ../finish
---

For our Application example, we'll launch a copy of Etherpad and configure it for use with the db:

### Run the Application

Let's give it a try! Deploy `etherpad` with:

```execute-1
export DB_SVC="mycluster.${PGO_NAMESPACE}.svc.cluster.local"
export DB_REPLICA_SVC="mycluster-replica.${PGO_NAMESPACE}.svc.cluster.local"
oc new-app -p DB_HOST=$DB_SVC -f etherpad-template.yaml
```

You should see output similar to this:

```
--> Deploying template "postgres-lab-workshops-n3v3r/etherpad" for "https://raw.githubusercontent.com/ryanj/docker-openshift-et
herpad/master/etherpad-template.yaml" to project postgres-lab-workshops-n3v3r                                              

     Etherpad                                                                                                                  
     ---------                                                                                                                 
     A realtime collaborative editor                                                                                           

     * With parameters:                                                                                                        
        * NAME=etherpad                                                                                                        
        * ADMIN_PASSWORD=etherpad                                                                                              
        * DB_DBID=etherpad                                                                                                     
        * DB_HOST=mycluster.postgres-lab-workshops-n3v3r.svc.cluster.local                                                     
        * DB_USER=etherpad                                                                                                     
        * DB_TYPE=postgres                                                                                                     
        * DB_PASS=etherpad                                                                                                  
        * DB_PORT=5432                                                                                                         
        * ETHERPAD_IMAGE=quay.io/wkulhanek/etherpad:latest                                                                     

--> Creating resources ...                                                                                                     
    deploymentconfig.apps.openshift.io "etherpad" created                                                                      
    service "etherpad" created                                                                                                 
    route.route.openshift.io "etherpad" created                                                                                
    configmap "etherpad-settings" created                                                                                      
--> Success                                                                                                                    
    Access your application via route 'etherpad-postgres-lab-workshops-n3v3r.apps.ryanj-2a63.openshiftworkshop.com'            
    Run 'oc status' to view your app.
```

The `etherpad` host address should be visible in the output, but you can also look it up later with `get routes`:

```execute-1
oc get routes
```

The URL should be:

http://etherpad-%project_namespace%.%cluster_subdomain%/

This may take a minute or more to download and boot the image, and to initialize the database using our established credentials.  Watch for a `1/1` Ready status from our `etherpad` pod using the watcher we already have running. You can also monitor the status of the deployment using:

```execute
oc rollout status dc/etherpad
```

After the `etherpad` pod reports "Ready 1/1" you should be able to connect to the app, write some test data, and verify that etherpad is working!

![New Pad](new-etherpad.png)

***Bonus Round:*** Try joining with a 2nd browser, or invite someone to collaborate!

![Realtime Collaboration with Etherpad](collaborate-with-etherpad.png)

### Final replication check
Etherpad stores it's data in a table named `store`.  

Let's query our replicas to see if they're up-to-date and ready to automatically replace any primary db nodes that might fail, or need to be rescheduled, migrated, upgraded, or disrupted in some other way:

```execute-1
psql -h $DB_REPLICA_SVC -U etherpad etherpad -c 'select * from store;'
```

Congratulations - If you've found data in this table, your then db replication for etherpad is working as expected!

## Summary

Now that you've completed this lab, you should be familiar with:
* How to create a Postgres Enterprise cluster using the Crunchy Enterprise Postgres operator
* How to create a Postgres database using the `pgo` command-line tool, and how to store and retrieve data using basic SQL statements
* How to validate Data Replication and High Availability features for this cluster
* How to power a realtime multiuser collaborative editor using your new highly-available PostgreSQL datastore!

Continue to the next page for more resources on OpenShift, Operators, and Postgres
