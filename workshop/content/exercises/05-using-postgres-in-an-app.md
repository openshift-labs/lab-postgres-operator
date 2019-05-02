---
Title: Using Postgres in an Application
PrevPage: 04-high-availability
NextPage: ../final
---

### Overview of the Application
provide a settings.json file to configure Etherpad:

https://github.com/ether/etherpad-lite/blob/develop/settings.json.template


1. provide a credentials.json file and/or settings.json to configure etherpad access to Postgres:


TODO: NEEDS WORK:   https://github.com/ether/etherpad-lite/wiki/How-to-use-Etherpad-Lite-with-PostgreSQL

2. boot etherpad, expose the service

### Run the Application

Let's give it a try! Deploy `etherpad` with:

```execute-1
kubectl run etherpad --image=etherpad --port=9001 --expose
```

You should see output similar to this:

```
deployment etherpad created
service etherpad created
```

Expose the service

```execute
oc expose svc etherpad
```

3. Connect to the app, write some data, verify that etherpad is working, try a 2nd browser?


## Summary

Now that you've completed this lab, you should be familiar with:
* How to create a Postgres Enterprise cluster using the Crunchy Enterprise Postgres operator
* How to create a Postgres database using the `pgo` command-line tool, and how to store and retrieve data using basic SQL statements
* How to validate Data Replication and High Availability features for this cluster
* How to connect our Etherpad example application to the Postgres datastore

Continue to the next page for more resources on OpenShift, Operators, and Postgres.
