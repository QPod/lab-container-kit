# Distributed under the terms of the Modified BSD License.

ARG BASE_NAMESPACE
ARG BASE_IMG="atom"
FROM ${BASE_NAMESPACE:+$BASE_NAMESPACE/}${BASE_IMG} AS runner

LABEL maintainer="haobibo@gmail.com"

COPY work /opt/utils/

RUN source /opt/utils/script-setup-k0s.sh \
 && setup_k0s && setup_k0s_pack && setup_kubectl \
 && ls -alh /opt/k0s/

FROM docker.io/busybox
COPY --from=runner /opt/k0s /opt/k0s
LABEL usage="docker run --rm -it -v /opt/k0s:/tmp k0s"
CMD ["sh", "-c", "ls -alh /opt/k0s && cp -rf /opt/k0s/* /tmp/"]
