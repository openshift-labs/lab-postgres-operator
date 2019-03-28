---
Sort: 1
Title: Workshop Overview
NextPage: exercises/01-operator-prerequisites
ExitSign: Start Workshop
---

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
