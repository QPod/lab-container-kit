# Distributed under the terms of the Modified BSD License.

ARG BASE_NAMESPACE
ARG BASE_IMG="atom"
FROM ${BASE_NAMESPACE:+$BASE_NAMESPACE/}${BASE_IMG} AS runner

LABEL maintainer="haobibo@gmail.com"

COPY work /opt/utils/

RUN set -eux \
 && source /opt/utils/script-setup-k8s-common.sh    && setup_kubectl && setup_helm \
 && source /opt/utils/script-setup-k3s.sh           && setup_k3s && setup_cri_dockerd && setup_k3s_pack \
 && mv /opt/utils/script-setup-k3s.sh   /opt/k3s/ \
 && mv /opt/k8s/*                       /opt/k3s/ && rm -rf /opt/k8s \
 && ls -alh /opt/*


FROM docker.io/busybox
COPY --from=runner /opt/k3s /opt/k3s
LABEL usage="docker run --rm -it -v /opt/k3s/:/tmp/ k3s"
CMD ["sh", "-c", "ls -alh /opt/k3s && cp -rf /opt/k3s/* /tmp/"]
