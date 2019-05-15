FROM docker:stable-dind

ENV K3S_VERSION=v0.5.0
EXPOSE 8443

ADD https://github.com/rancher/k3s/releases/download/${K3S_VERSION}/k3s /usr/local/bin/k3s
COPY kubectl start-k3s.sh /usr/local/bin/

# Note: the k3s kubectl command unpacks the k3s binaries as a side effect
RUN  apk --no-cache add bash && \
    chmod a+x \
        /usr/local/bin/k3s \
        /usr/local/bin/start-k3s.sh \
        /usr/local/bin/kubectl \
        && \
    k3s kubectl --help > /dev/null

ENTRYPOINT [ "/usr/local/bin/start-k3s.sh" ]
