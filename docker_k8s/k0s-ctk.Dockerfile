# Distributed under the terms of the Modified BSD License.

ARG BASE_NAMESPACE
ARG BASE_IMG="atom"
FROM ${BASE_NAMESPACE:+$BASE_NAMESPACE/}${BASE_IMG} AS runner

LABEL maintainer="haobibo@gmail.com"

COPY work /opt/utils/

RUN source /opt/utils/script-setup-k8s-common.sh    && setup_kubectl && setup_helm \
 && source /opt/utils/script-setup-k0s.sh           && setup_k0s  && setup_k0s_pack \
 && mv /opt/utils/script-setup-k0s.sh   /opt/k0s/ \
 && mv /opt/k8s/*                       /opt/k0s/ && rm -rf /opt/k8s \
 && ls -alh /opt/*


FROM docker.io/busybox
COPY --from=runner /opt/k0s /opt/k0s
LABEL usage="docker run --rm -it -v /opt/k0s:/tmp k0s"
CMD ["sh", "-c", "ls -alh /opt/k0s && cp -rf /opt/k0s/* /tmp/"]
