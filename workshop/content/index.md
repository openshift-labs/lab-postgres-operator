---
Sort: 1
Title: Workshop Overview
NextPage: exercises/01-operator-prerequisites
ExitSign: Start Workshop
---

The [Wikipedia](https://en.wikipedia.org/wiki/PostgreSQL) site describes Postgres as a:

> object-relational database management system (ORDBMS) with an emphasis on extensibility and standards compliance. It can handle workloads ranging from small single-machine applications to large Internet-facing applications (or for data warehousing) with many concurrent users.

Before you can use Postgres for your applications, you need to deploy a Postgres server cluster.

In this workshop, you will learn how to create a Postgres cluster using the Postgres operator.


```execute-1
oc rollout status deployment/postgres-operator
```

```execute-1
pgo version
```

```execute-2
oc get pods --watch
```

```execute-1
pgo create cluster mycluster --replica-count=2
```

```execute-2
<ctrl+c>
```
