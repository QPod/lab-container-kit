setup_kubectl() {
  ARCH="amd64"
  # https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-kubectl-binary-with-curl-on-linux
     VER_KUBECTL=$(curl -L -s https://dl.k8s.io/release/stable.txt) \
  && URL_KUBECTL="https://dl.k8s.io/release/$VER_KUBECTL/bin/linux/amd64/kubectl" \
  && echo "Downloading kubectl version ${VER_KUBECTL} from: ${URL_KUBECTL}" \
  && curl -L -o /opt/k3s/kubectl $URL_KUBECTL \
  && chmod +x /opt/k8s/kubectl && ln -sf /opt/k8s/kubectl /usr/local/bin/
}

setup_helm() {
  ARCH="amd64"
  VER_HELM=$(curl -s https://api.github.com/repos/helm/helm/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') \
  && URL_HELM="https://get.helm.sh/helm-${VER_HELM}-linux-${ARCH}.tar.gz" \
  && echo "Downloading Helm version ${VER_HELM} from: ${URL_HELM}" \
  && curl -L -s -o /tmp/helm.tar.gz "${URL_HELM}" \
  && tar -zxvf /tmp/helm.tar.gz -C /opt/k8s/ --strip-components=1 "linux-${ARCH}/helm" \
  && chmod +x /opt/k8s/helm && ln -sf /opt/k8s/helm /usr/local/bin/
  helm version
}
