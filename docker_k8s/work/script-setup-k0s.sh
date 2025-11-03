# k0s Air-gap Install: https://docs.k0sproject.io/head/airgap-install/
set -ex

ARCH=$(uname -m | sed -e 's/x86_64/amd64/' -e 's/aarch64/arm64/')

setup_k0s() {
     VER_K0S=$(curl -sL https://github.com/k0sproject/k0s/releases.atom | grep 'releases/tag/v' | head -1 | grep -Po '\d[\d.]+' ) \
  && URL_K0S="https://github.com/k0sproject/k0s/releases/download/v${VER_K0S}%2Bk0s.0/k0s-v${VER_K0S}+k0s.0-${ARCH}" \
  && echo "Downloading k0s version ${VER_K0S} from ${URL_K0S}" \
  && mkdir -pv /opt/k0s && curl -L -o /opt/k0s/k0s ${URL_K0S} \
  && chmod +x /opt/k0s/k0s
  /opt/k0s/k0s version
}

setup_k0s_pack() {
     VER_K0S=$(curl -sL https://github.com/k0sproject/k0s/releases.atom | grep 'releases/tag/v' | head -1 | grep -Po '\d[\d.]+' ) \
  && URL_K0S_IMG="https://github.com/k0sproject/k0s/releases/download/v${VER_K0S}+k0s.0/k0s-airgap-bundle-v${VER_K0S}+k0s.0-${ARCH}" \
  && echo "Downloading k0s airgap images version ${VER_K0S} from ${URL_K0S_IMG}" \
  && curl -L -o "/opt/k0s/k0s-airgap-bundle-v${VER_K0S}+k0s.0-${ARCH}" ${URL_K0S_IMG}
}
