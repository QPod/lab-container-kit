# k8s reload images

## k3s

```bash
docker run --rm -it -v /opt/k3s/:/tmp/ quay.io/labnow/k3s-ctk

cd /opt/k3s

zstd -cd ./k3s-airgap-images-${ARCH:-amd64}.tar.zst | docker load

source ./script-setup-k3s.sh && create_cri_dockerd_unit_files

INSTALL_K3S_SKIP_DOWNLOAD=true INSTALL_K3S_BIN_DIR=/opt/k3s ./script-get-k3s-io.sh --docker -data-dir /data/storage/data-k3s

sudo ln -sf /opt/k3s/k3s* /opt/k3s/kubectl /opt/k3s/cri-docker /usr/local/bin/
```
