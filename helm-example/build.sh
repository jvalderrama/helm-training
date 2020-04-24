VERSION=$1
echo "Construyendo version: $VERSION"
docker build -t "localhost:32000/myapp:$VERSION" .
docker push "localhost:32000/myapp:$VERSION"
#helm dependency update helm-chart
helm push helm-chart --version="$VERSION" chartmuseum-mycompany
