setup_k3s() {
  ARCH="amd64"
  #  Install the latest release: https://github.com/k3d-io/k3s
     VER_K3S=$(curl -sL https://github.com/k3s-io/k3s/releases.atom | grep 'releases/tag/v' | grep -v 'rc' | head -1 | grep -Po '\d[\d.]+' ) \
  && URL_K3S="https://github.com/k3s-io/k3s/releases/download/v$VER_K3S%2Bk3s1/k3s" \
  && echo "Downloading k3s version ${VER_K3S} from: ${URL_K3S}" \
  && mkdir -pv /opt/k3s && curl -L -o /opt/k3s/k3s $URL_K3S \
  && chmod +x /opt/k3s/*k3s*
  /opt/k3s/k3s --version
}

setup_cri_dockerd() {
  ARCH="amd64"
  #  Install the latest release: https://mirantis.github.io/cri-dockerd/usage/install-manually/
     VER_CRI_DOCKERD=$(curl -sL https://github.com/Mirantis/cri-dockerd/releases.atom | grep 'releases/tag/v' | grep -v 'rc' | head -1 | grep -Po '\d[\d.]+' ) \
  && URL_CRI_DOCKERD="https://github.com/Mirantis/cri-dockerd/releases/download/v$VER_CRI_DOCKERD/cri-dockerd-$VER_CRI_DOCKERD.$ARCH.tgz" \  
  && echo "Downloading cri-dockerd version ${VER_CRI_DOCKERD} from: ${URL_CRI_DOCKERD}" \
  && mkdir -pv /opt/k3s && curl -L -o /tmp/cri-dockerd.tgz $URL_CRI_DOCKERD \
  && tar -xzvf /tmp/cri-dockerd.tgz -C /opt/k3s/ --strip-components=1 cri-dockerd/cri-dockerd \
  && chmod +x /opt/k3s/cri-dockerd
  /opt/k3s/cri-dockerd --version
}


setup_k3s_pack() {
  # Download k3s image for offline-mode installation
     VER_K3S=$(curl -sL https://github.com/k3s-io/k3s/releases.atom | grep 'releases/tag/v' | grep -v 'rc' | head -1 | grep -Po '\d[\d.]+' ) \
  && URL_K3S_IMGS="https://github.com/k3s-io/k3s/releases/download/v$VER_K3S%2Bk3s1/k3s-airgap-images-amd64.tar.zst" \
  && curl -L -o /opt/k3s/k3s-airgap-images-amd64.tar.zst $URL_K3S_IMGS
  # zstd -cd ./k3s-airgap-images-amd64.tar.zst | docker load
  # INSTALL_K3S_SKIP_DOWNLOAD=true ./install_k3s.sh
}


create_cri_dockerd_unit_files() {
    local SYSTEMD_DIR="/etc/systemd/system"
    local FILE_SOCKET="${SYSTEMD_DIR}/cri-docker.socket"
    local FILE_SERVICE="${SYSTEMD_DIR}/cri-docker.service"

    tee "${FILE_SOCKET}" >/dev/null <<'EOF'
[Unit]
Description=CRI Docker Socket for the API
PartOf=cri-docker.service

[Socket]
ListenStream=/var/run/cri-dockerd.sock
SocketMode=0660
SocketUser=root
SocketGroup=docker

[Install]
WantedBy=sockets.target
EOF

    tee "${FILE_SERVICE}" >/dev/null <<'EOF'
[Unit]
Description=CRI Interface for Docker Application Container Engine
Documentation=https://docs.mirantis.com
After=network-online.target firewalld.service docker.service
Wants=network-online.target
Requires=cri-docker.socket

[Service]
Type=notify
ExecStart=/opt/k3s/cri-dockerd --container-runtime-endpoint fd://
ExecReload=/bin/kill -s HUP $MAINPID
TimeoutSec=0
RestartSec=2
Restart=always
StartLimitBurst=3
StartLimitInterval=60s
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity

# Comment TasksMax if your systemd version does not support it.
TasksMax=infinity
Delegate=yes
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

    echo "Created: ${FILE_SOCKET} and ${FILE_SERVICE}"
}


create_systemd_service_file() {
    FILE_K3S_SERVICE=${FILE_K3S_SERVICE:-"/etc/systemd/system/k3s.service"}
    echo "systemd: Creating service file ${FILE_K3S_SERVICE}"
    $SUDO tee ${FILE_K3S_SERVICE} >/dev/null << EOF
[Unit]
Description=Lightweight Kubernetes
Documentation=https://k3s.io
Wants=network-online.target
After=network-online.target

[Install]
WantedBy=multi-user.target

[Service]
Type=${SYSTEMD_TYPE:="notify"}
EnvironmentFile=-/etc/default/%N
EnvironmentFile=-/etc/sysconfig/%N
EnvironmentFile=-${FILE_K3S_ENV:-"/opt/k3s/k3s.service.env"}
KillMode=process
Delegate=yes
User=root
# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNOFILE=1048576
LimitNPROC=infinity
LimitCORE=infinity
TasksMax=infinity
TimeoutStartSec=0
Restart=always
RestartSec=5s
ExecStartPre=-/sbin/modprobe br_netfilter
ExecStartPre=-/sbin/modprobe overlay
ExecStart=${BIN_DIR:-"/opt/k3s"}/k3s ${CMD_K3S_EXEC:-"server"} ${CMD_K3S_EXTRA_ARGS:="--docker --disable-traefik"}
EOF
}
