# App Example

This is the corresponding chart for the example app present in this repository

## Deploy
```
helm install . --set image=<APP IMAGE>
```

## Values
| Parameter                       | Description                                                     | Default                      |
| ------------------------------- | ----------------------------------------------------------------| -----------------------------|
| `image`              | App image                                  |  |
| `podAnnotations`                     | Annotations for the pods                                 |                  |
| `customVar`              | value for the env variable CUSTOM_VAR                               |                      |
| `replicas`                  | Number of replicas                                              | `1`                          |
