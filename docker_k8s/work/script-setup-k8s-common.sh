setup_verify_arch() {
    [ -z "$ARCH" ] && ARCH=$(uname -m)
    case $ARCH in
        amd64|x86_64)  export ARCH=amd64; export SUFFIX= ;;
        arm64|aarch64) export ARCH=arm64; export SUFFIX=-arm64 ;;
        s390x)         export ARCH=s390x; export SUFFIX=-s390x ;;
        arm*)          export ARCH=arm;   export SUFFIX=-armhf ;;
        *) fatal "Unsupported architecture $ARCH" ;;
    esac
}


setup_kubectl() {
  # https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-kubectl-binary-with-curl-on-linux
     VER_KUBECTL=$(curl -L -s https://dl.k8s.io/release/stable.txt) \
  && URL_KUBECTL="https://dl.k8s.io/release/$VER_KUBECTL/bin/linux/$ARCH/kubectl" \
  && echo "Downloading kubectl version ${VER_KUBECTL} from: ${URL_KUBECTL}" \
  && mkdir -pv /opt/k8s \
  && curl -L -o /opt/k8s/kubectl $URL_KUBECTL \
  && chmod +x /opt/k8s/kubectl
  /opt/k8s/kubectl version --client
}

setup_helm() {
  VER_HELM=$(curl -s https://api.github.com/repos/helm/helm/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') \
  && URL_HELM="https://get.helm.sh/helm-${VER_HELM}-linux-${ARCH}.tar.gz" \
  && echo "Downloading Helm version ${VER_HELM} from: ${URL_HELM}" \
  && curl -L -s -o /tmp/helm.tar.gz "${URL_HELM}" \
  && mkdir -pv /opt/k8s \
  && tar -zxvf /tmp/helm.tar.gz -C /opt/k8s/ --strip-components=1 "linux-${ARCH}/helm" \
  && chmod +x /opt/k8s/helm
  /opt/k8s/helm version
}
