docker build -t ubuntu-systemd -f ./systemd.Dockerfile .

docker rm -f ubuntu-systemd

docker run -d \
    --name=ubuntu-systemd \
    --hostname=ubuntu-systemd \
    --cgroupns=host \
    --tmpfs /run \
    --tmpfs /run/lock \
    -v /sys/fs/cgroup:/sys/fs/cgroup \
    ubuntu-systemd


INSTALL_K3S_SKIP_DOWNLOAD=true ./install_k3s.sh --disable=traefik,servicelb --write-kubeconfig-mode 644
