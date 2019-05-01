FROM alpine:3.9

ENV RELEASE="$(curl -sSL https://dl.k8s.io/release/stable.txt)"

RUN apk add --no-cache bash curl sudo
#    adduser -u 1000 -G wheel -D alpine && \
#    rm -rf /var/cache/apk/*
#
#USER alpine

RUN mkdir -p /opt/bin && \
    cd /opt/bin && \
    curl -L --remote-name-all https://storage.googleapis.com/kubernetes-release/release/${RELEASE}/bin/linux/amd64/{kubeadm,kubelet,kubectl} && \
    chmod +x kubeadm kubelet kubectl

ENV PATH "$PATH:/opt/bin"

RUN curl -sSL "https://raw.githubusercontent.com/kubernetes/kubernetes/${RELEASE}/build/debs/kubelet.service" | sed "s:/usr/bin:/opt/bin:g" > /etc/systemd/system/kubelet.service && \
    mkdir -p /etc/systemd/system/kubelet.service.d && \
    curl -sSL "https://raw.githubusercontent.com/kubernetes/kubernetes/${RELEASE}/build/debs/10-kubeadm.conf" | sed "s:/usr/bin:/opt/bin:g" > /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

#RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_VERSION}/bin/linux/amd64/kubectl && \
#    chmod +x ./kubectl && \
#    mv ./kubectl /usr/local/bin/kubectl && \
#    kubectl version