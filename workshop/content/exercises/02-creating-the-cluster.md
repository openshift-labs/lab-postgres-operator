---
Title: Creating the Cluster
PrevPage: 01-operator-prerequisites
NextPage: ../finish
---

```execute-2
oc get pods --watch
```

```execute-1
pgo create cluster mycluster --replica-count=2
```

```execute-2
<ctrl+c>
```
