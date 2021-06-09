export KUBECONFIG=~/tdc/kind/kubeconfig

# Download kind from https://github.com/kubernetes-sigs/kind/releases
# Or with go get sigs.k8s.io/kind@v0.11.1

# Create the cluster
kind create cluster

# Let's see our cluster running, as a docker container
docker ps

# Deploy the http server (pod & service)
kubectl apply -f deploy-nginx.yaml

# Deploy a pod that will serve as client
kubectl apply -f deploy-sleep.yaml

# Test a call from client -> server
kubectl exec -it sleep -- curl http://nginx/

### Loading images ###

# Let's create another image to use in our deployment
docker build -t registro-falso.io/tdc/nginx:v1 .

# Change the deployment to use this new image
kubectl edit deploy nginx
kubectl get pods # Pod will fail with ErrImagePull/ImagePullBackOff

# List available images in the kind cluster
docker exec -it kind-control-plane crictl images

# Load our custom image into kind cluster
kind load docker-image registro-falso.io/tdc/nginx:v1

# This image should show up in kind cluster
docker exec -it kind-control-plane crictl images

# If we look now, pod should be up and running the new image:
kubectl get pods
kubectl get pods -l app=nginx -o yaml | grep image

# Test the server with the new home page
kubectl exec -it sleep -- curl http://nginx/

# Note PullPolicy must be IfNotPresent or Never


# Creating another cluster
kind create cluster --name 1.19 --image kindest/node:v1.19.11
docker ps
kubectl --context kind-kind version
kubectl --context kind-1.19 version

# Removing a cluster
kind get clusters
kind delete cluster --name 1.19
kind get clusters
kubectl config use-context kind-kind

# Customizing your cluster - https://kind.sigs.k8s.io/docs/user/configuration/
kind create cluster --name 3nodes --config 3nodes.yaml
kind get clusters
docker ps
kubectl get nodes

# Clean up
kind delete clusters --all
docker ps
