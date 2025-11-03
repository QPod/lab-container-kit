setup_k3d() {
  #  Install the latest release: https://github.com/k3d-io/k3d
     VER_K3D=$(curl -sL https://github.com/k3d-io/k3d/releases.atom | grep 'releases/tag/v' | head -1 | grep -Po '\d[\d.]+' ) \
  && URL_K3D="https://github.com/k3d-io/k3d/releases/download/v$VER_K3D/k3d-linux-$ARCH" \
  && echo "Downloading k3d version ${VER_K3D} from: ${URL_K3D}" \
  && mkdir -pv /opt/k3s && curl -L -o /opt/k3s/k3d $URL_K3D \
  && curl -L -o /opt/k3s/install_k3d.sh https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh \
  && chmod +x /opt/k3s/*k3d*

  /opt/k3s/k3d --version
}
