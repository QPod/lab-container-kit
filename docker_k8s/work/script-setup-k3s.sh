setup_k3d() {
  ARCH="amd64"
  #  Install the latest release: https://github.com/k3d-io/k3d
     VER_K3D=$(curl -sL https://github.com/k3d-io/k3d/releases.atom | grep 'releases/tag/v' | head -1 | grep -Po '\d[\d.]+' ) \
  && URL_K3D="https://github.com/k3d-io/k3d/releases/download/v$VER_K3D/k3d-linux-$ARCH" \
  && echo "Downloading k3d version ${VER_K3D} from: ${URL_K3D}" \
  && mkdir -pv /opt/k3s && curl -L -o /opt/k3s/k3d $URL_K3D \
  && curl -L -o /opt/k3s/install_k3d.sh https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh \
  && chmod +x /opt/k3s/*k3d* && ln -sf /opt/k3s/k3d /usr/local/bin/

  k3d --version
}

setup_k3s() {
  ARCH="amd64"
  #  Install the latest release: https://github.com/k3d-io/k3s
     VER_K3S=$(curl -sL https://github.com/k3s-io/k3s/releases.atom | grep 'releases/tag/v' | grep -v 'rc' | head -1 | grep -Po '\d[\d.]+' ) \
  && URL_K3S="https://github.com/k3s-io/k3s/releases/download/v$VER_K3S%2Bk3s1/k3s" \
  && echo "Downloading k3s version ${VER_K3S} from: ${URL_K3S}" \
  && mkdir -pv /opt/k3s && curl -L -o /opt/k3s/k3s $URL_K3S \
  && curl -L -o /opt/k3s/install_k3s.sh https://get.k3s.io \
  && chmod +x /opt/k3s/*k3s* && ln -sf /opt/k3s/k3s /usr/local/bin/

  k3s --version
}

setup_k3s_pack() {
  # Download k3s image for offline-mode installation
     VER_K3S=$(curl -sL https://github.com/k3s-io/k3s/releases.atom | grep 'releases/tag/v' | grep -v 'rc' | head -1 | grep -Po '\d[\d.]+' ) \
  && URL_K3S_IMGS="https://github.com/k3s-io/k3s/releases/download/v$VER_K3S%2Bk3s1/k3s-airgap-images-amd64.tar.zst" \
  && curl -L -o ./k3s-airgap-images-amd64.tar.zst $URL_K3S_IMGS
  # zstd -cd ./k3s-airgap-images-amd64.tar.zst | docker load
  # INSTALL_K3S_SKIP_DOWNLOAD=true ./install_k3s.sh
}


setup_kubectl() {
  ARCH="amd64"
  # https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-kubectl-binary-with-curl-on-linux
     VER_KUBECTL=$(curl -L -s https://dl.k8s.io/release/stable.txt) \
  && URL_KUBECTL="https://dl.k8s.io/release/$VER_KUBECTL/bin/linux/amd64/kubectl" \
  && echo "Downloading kubectl version ${VER_KUBECTL} from: ${URL_KUBECTL}" \
  && curl -L -o /opt/k3s/kubectl $URL_KUBECTL \
  && chmod +x /opt/k3s/kubectl && ln -sf /opt/k3s/kubectl /usr/local/bin/
}
