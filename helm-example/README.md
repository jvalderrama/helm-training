# App Example

This is a simple web server in Python Flask to demonstrate deployments using Helm and Skaffold.

## Components
- `app.py`: Python Flask code

- `requirements.txt`: Python dependencies

- `Dockerfile`

- `helm-chart`: chart to deploy the app in Kubernetes

- `skaffold.yaml`: Skaffold conf file

- `build.sh`: script to automatically build and push the app

- `deploy.sh`: script to automatically deploy any version in any environment

## Build and push

Edit build.sh to match your docker registry (default `localhost:32000`) and the name of your Helm repository (default `myrepo`)

Then exec

```
./build.sh 1.0.0
```

To build and push a new version called `1.0.0`

## Deploy with Helm

Again edit deploy.sh to match your docker registry (default `localhost:32000`) and the name of your Helm repository (default `myrepo`)

Then exec

```
./deploy.sh 1.0.0 development DEVLOPMENT_ENVIRONMENT
```

To deploy version `1.0.0` to a namespace called `development` (that must exist) and setting the env variable `CUSTOM_VAR` to `DEVLOPMENT_ENVIRONMENT`

## Develop with Skaffold

Just run

```
skaffold dev --port-forward
```

To deploy a new environment in Kubernetes for development. It will sync the app.py file and forward the port 5000 to your localhost.

Just access the service in http://localhost:5000
