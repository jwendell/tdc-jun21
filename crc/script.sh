export KUBECONFIG=~/tdc/crc/kubeconfig

# Download crc from https://cloud.redhat.com/openshift/create/local

# Create the cluster
crc setup # First time only
crc start

oc version
oc cluster-info
oc get nodes

xdg-open https://console-openshift-console.apps-crc.testing

