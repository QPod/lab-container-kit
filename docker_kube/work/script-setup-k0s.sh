# k0s Air-gap Install: https://docs.k0sproject.io/head/airgap-install/

setup_k0s() {
     VER_K0S=$(curl -sL https://docs.k0sproject.io/stable.txt) \
  && URL_K0S="https://github.com/k0sproject/k0s/releases/download/${VER_K0S}/k0s-${VER_K0S}-${ARCH}" \
  && echo "Downloading k0s version ${VER_K0S} from ${URL_K0S}" \
  && mkdir -pv /opt/k0s && curl -L -o /opt/k0s/k0s ${URL_K0S} \
  && chmod +x /opt/k0s/k0s
  /opt/k0s/k0s version
}

setup_k0s_pack() {
     VER_K0S=$(curl -sL https://docs.k0sproject.io/stable.txt) \
  && URL_K0S_IMG="https://github.com/k0sproject/k0s/releases/download/${VER_K0S}/k0s-airgap-bundle-${VER_K0S}-${ARCH}" \
  && echo "Downloading k0s airgap images version ${VER_K0S} from ${URL_K0S_IMG}" \
  && curl -L -o "/opt/k0s/k0s-airgap-bundle-${VER_K0S}-${ARCH}" ${URL_K0S_IMG}
}
