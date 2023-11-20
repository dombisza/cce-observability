ARG BUILD_DATE

FROM debian:bookworm-20231030
LABEL org.opencontainers.image.authors="Open Telekom Cloud <szabolcs-andras.dombi@t-systems.com>"
LABEL org.opencontainers.image.description="Helmfile and Terraform environment for deploying loki-stack on OTC"
LABEL org.opencontainers.image.title="loki-deployer"
LABEL org.opencontainers.image.url="https://git.tsi-dev.otc-service.com/cse/loki-stack"
LABEL org.opencontainers.image.base.name="debian:bookworm-20231030"
LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.docker.cmd="docker run -it -v$(pwd):/deploy -v$HOME/.docker/config.json:/root/.docker/config.json -v$HOME/.kube/config:/root/.kube/config loki-deployer:latest"
LABEL org.opencontainers.image.docker.build.cmd="docker build --no-cache=true --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') --tag loki-deployer:latest ."

ENV BUILD_PKG="unzip wget git curl ca-certificates"
ENV RUNTIME_PKG="jq make vim"

ENV HELMFILE_V="0.158.1"
ENV OTC_AUTH_V="2.0.7"
ENV KUBECTL_V="1.25.15"

RUN apt-get update -y \
 && echo "===### INSTALLING DEPENDENCIES ###===" \
 && apt-get install -y --no-install-recommends ${BUILD_PKG} ${RUNTIME_PKG} \
 && echo "===### INSTALLING HELM3 ###===" \
 && curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
 && chmod 700 get_helm.sh \
 && ./get_helm.sh \
 && echo "===### INSTALLING HELMFILE ###===" \
 && wget https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_V}/helmfile_${HELMFILE_V}_linux_amd64.tar.gz \
 && tar xvf helmfile_${HELMFILE_V}_linux_amd64.tar.gz \
 && mv helmfile /usr/local/bin/helmfile \
 && echo "===### INSTALLING OTCAUTH ###===" \
 && wget https://github.com/iits-consulting/otc-auth/releases/download/v${OTC_AUTH_V}/otc-auth_${OTC_AUTH_V}_amd64.deb \
 && dpkg -i otc-auth_${OTC_AUTH_V}_amd64.deb \
 && echo "===### INSTALLING KUBECTL ###===" \
 && wget https://dl.k8s.io/v${KUBECTL_V}/kubernetes-client-linux-amd64.tar.gz \
 && tar xvf kubernetes-client-linux-amd64.tar.gz \
 && mv kubernetes/client/bin/kubectl /usr/local/bin/ \
 && echo "===### INSTALLING TFENV ###===" \
 && git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv \
 && echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile \
 && ln -s ~/.tfenv/bin/* /usr/local/bin
WORKDIR /deploy
ENTRYPOINT ["/bin/bash"]
