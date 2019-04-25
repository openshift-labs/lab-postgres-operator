---
Title: Using Postgres in an Application
PrevPage: 03-creating-the-database
NextPage: 05-high-availability
---

### Overview of the Application
provide a settings.json file to configure Etherpad:

https://github.com/ether/etherpad-lite/blob/develop/settings.json.template

1. provide a credentials.json file to configure etherpad access to Postgres:

     https://github.com/ether/etherpad-lite/wiki/How-to-use-Etherpad-Lite-with-PostgreSQL

2. boot etherpad, expose the service

### Run the Application

Let's give it a try! Deploy `etherpad` with:

```execute-1
kubectl run etherpad
```

You should see output similar to this:

```
deployment etherpad created
```

Expose the service

```
kubectl expose deployment etherpad
oc expose svc etherpad
```

3. Connect to the app, write some data, verify that etherpad is working, try a 2nd browser?

4. Take a new snapshot of the database (with our latest, live etherpad data)

```execute-1
pgo backup mycluster --backup-type=pgbackrest
```
