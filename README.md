# Helm - Training for Continuos Integration and Local Development with Skaffold

## Install microk8s and helm3 on local

```
sudo snap install microk8s --classic
sudo micrko8s.start
microk8s.config > /tmp/kubeconfig
export KUBECONFIG=/tmp/kubeconfig
sudo snap install helm --classic
helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm repo update
```

## Deploy app with different versions and rollback to a specific app version

```
helm install nginx-mycompany stable/nginx-ingress --version 1.36.2
helm list
helm upgrade --install nginx-mycompany stable/nginx-ingress --version 1.36.3
helm list
helm history nginx-mycompany
helm rollback nginx-mycompany 1
```

## Enable storage, registry and DNS service and allow port forward for volumes on microk8s local cluster

```
sudo microk8s.enable storage
sudo microk8s.enable registry
sudo microk8s enable dns
sudo iptables -P FORWARD ACCEPT
sudo snap disable microk8s
sudo snap enable microk8s
```

## Create private repository to store Charts

Note: https://hub.kubeapps.com/charts/stable/chartmuseum

```
helm install chartmuseum-mycompany stable/chartmuseum --values values.yaml
helm repo update
kubectl get svc (Get chartmuseum endpoint)
```

Ex: http://10.152.183.169:8080 and add this repo to your Helm

```
helm repo add chartmuseum-mycompany http://10.152.183.169:8080
```

## Deploy KubeApps (UI) in our local microk8s cluster

Note: https://github.com/kubeapps/kubeapps/blob/master/docs/user/getting-started.md

```
helm repo add bitnami https://charts.bitnami.com/bitnami
kubectl create namespace kubeapps
helm repo update
helm install kubeapps-mycompany --namespace kubeapps bitnami/kubeapps --set useHelm3=true
kubectl get pods --namespace=kubeapps
kubectl get svc --namespace=kubeapps
kubectl create serviceaccount kubeapps-operator
kubectl create clusterrolebinding kubeapps-operator --clusterrole=cluster-admin --serviceaccount=default:kubeapps-operator
kubectl port-forward -n kubeapps svc/kubeapps-mycompany 8080:80
```
In your localhost go to http://127.0.0.1:8080 and with the next command get the Token API to authenticate against kubeapps

```
kubectl get secret $(kubectl get serviceaccount kubeapps-operator -o jsonpath='{range .secrets[*]}{.name}{"\n"}{end}' | grep kubeapps-operator-token) -o jsonpath='{.data.token}' -o go-template='{{.data.token | base64decode}}' && echo
```

## Deploy app python server manually

```
cd helm-example
docker build -t localhost:32000/myapp:latest . 
docker run -p 5000:5000 --name example localhost:32000/myapp:latest
http://localhost:5000
docker push localhost:32000/myapp:latest
helm install app-mycompany helm-chart --set image=localhost:32000/myapp:latest
helm upgrade app-mycompany helm-chart --set image=localhost:32000/myapp:latest --set customVar='MyCompany'
helm rollback app-mycompany 1
```

Note: Modificar el Chart.yaml en su version, para que se vea reflejado el tema de releases and Values.yaml para replicas
Note: Modify "version" key on Chart.yaml to show the releases cycle and also modify "replicas" key for cluster k8s changes reflected in deployment

```
helm upgrade app-mycompany helm-chart --set image=localhost:32000/myapp:latest --set customVar='MyCompany1'
helm uninstall app-mycompany
```

## Continuos Integration with Helm and private Charts repository

Note: https://github.com/chartmuseum/helm-push

```
helm plugin install https://github.com/chartmuseum/helm-push.git
```

Note: Modify Chart.yaml to 1.0.3 version 

```
./build.sh 1.0.3 (Note: Script to generate applications versions and store it)
helm repo update
helm search repo app-example
kubectl create ns develop
./deploy.sh 1.0.3 develop hello_from_develop (Note: Deploy appplication in cluster and specific namespace once generate before with build.sh)
kubectl get pods -n develop
kubectl get svc -n develop
```

Note: Change Chart.yaml to version 1.0.4 and Python server app.py to version 1.0.4 and run:

```
./build.sh 1.0.4
./deploy.sh 1.0.4 develop hello_from_develop
```

# Skaffold local k8s development

Note: https://skaffold.dev/ (All environment are the same, keep the same at all)
Explanation: Sync manual en skaffold.yaml to share  between local and kubernetes pod deployment directories and ports

```
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
chmod +x skaffold
sudo mv skaffold /usr/local/bin
```

Note: Change Chart.yaml to version 1.0.6 and Python server app.py to version 1.0.6 and run:

```
helm list
helm history local-myapp
kubectl get pods
```

In your localhost go to http://localhost:5000/
Note: Change Python server app.py to version 1.0.7 and see in http://localhost:5000/ the changes automatically
Control+c to exit from skaffold terminal log and go to http://127.0.0.1:8080/#/ns/default/apps to see that local-myapp is gone. Also verified:

```
helm list
helm history local-myapp
kubectl get pods
```

The code example is a fork from https://github.com/OpenWebinarsNet/openwebinars-helm-example developed by @nachomillangarcia, thanks for the code, it was very usefull to make this training possible.
