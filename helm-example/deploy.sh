VERSION=$1
ENVIRONMENT=$2
CUSTOM_VAR=$3

echo "Desplegando version $VERSION en el entorno $ENVIRONMENT"
helm repo update
helm upgrade --install "$ENVIRONMENT-app-example" chartmuseum-mycompany/app-example \
--namespace $ENVIRONMENT \
--version $VERSION \
--set image=localhost:32000/myapp:$VERSION \
--set customVar=$CUSTOM_VAR
