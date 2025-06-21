# Distributed under the terms of the Modified BSD License.

ARG BASE_NAMESPACE
ARG BASE_IMG="atom"
FROM ${BASE_NAMESPACE:+$BASE_NAMESPACE/}${BASE_IMG} AS runner

LABEL maintainer="haobibo@gmail.com"

COPY work /opt/utils/

RUN source /opt/utils/script-setup-k3s.sh \
 && setup_k3s && setup_k3s_pack && setup_k3d && setup_kubectl \
 && ls -alh /opt/k3s/


FROM docker.io/busybox
COPY --from=runner /opt/k3s /opt/k3s
LABEL usage="docker run --rm -it -v /opt/k3s/:/tmp/ k3s"
CMD ["sh", "-c", "ls -alh /home && cp -rf /opt/k3s/* /tmp/"]
