# Distributed under the terms of the Modified BSD License.

ARG BASE_NAMESPACE
ARG BASE_IMG="atom"
FROM ${BASE_NAMESPACE:+$BASE_NAMESPACE/}${BASE_IMG}

LABEL maintainer="haobibo@gmail.com"

ENV continer=docker

# ref: https://github.com/robertdebock/docker-ubuntu-systemd/blob/master/Dockerfile

RUN source /opt/utils/script-setup-sys.sh \
 && setup_systemd && touch /etc/machine-id \
 && install__clean \
 rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/multi-user.target.wants/*  \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/basic.target.wants/* \
    /lib/systemd/system/anaconda.target.wants/* \
    /lib/systemd/system/plymouth* \
    /lib/systemd/system/systemd-update-utmp* \
 && cd /lib/systemd/system/sysinit.target.wants/ \
 && ls | grep -v systemd-tmpfiles-setup | xargs rm -f $1

STOPSIGNAL SIGRTMIN+3

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]

ENTRYPOINT [ "/usr/lib/systemd/systemd" ]
CMD [ "log-level=info", "unit=sysinit.target" ]
