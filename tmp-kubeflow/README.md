
URL_KUBEFLOW="https://github.com/kubeflow/manifests/archive/refs/heads/master.zip"

URL_KUBEFLOW="https://github.com/kubeflow/manifests/archive/refs/tags/v1.10.2.zip"


curl -L -o /opt/kubeflow/kubeflow-manifests.zip $URL_KUBEFLOW

unzip kubeflow-manifests.zip

cd /opt/kubeflow/manifests-*/applications

sudo kubectl apply -k common/kubeflow-namespace/base
sudo kubectl apply -k common/kubeflow-roles/base

sudo kubectl apply -k common/istio/istio-crds/base
sudo kubectl apply -k common/istio/istio-namespace/base
sudo kubectl apply -k common/istio/istio-install/base
sudo kubectl apply -k common/istio/kubeflow-istio-resources/base

sudo kubectl apply -k common/dex/overlays/istio
sudo kubectl apply -k common/oauth2-proxy/base

sudo kubectl apply -k applications/profile-controller/upstream/overlays/kubeflow
sudo kubectl apply -k applications/centraldashboard/upstream/overlays/istio


sudo kubectl apply -k applications/jupyter/notebook-controller/upstream/overlays/kubeflow/
sudo kubectl apply -k applications/jupyter/jupyter-web-app/upstream/overlays/istio/

sudo kubectl get pods -n kubeflow

sudo kubectl port-forward svc/jupyter-web-app-service -n kubeflow 8080:80

