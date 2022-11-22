FROM registry.access.redhat.com/ubi9/ubi-minimal:latest

LABEL maintainer="luzuccar@redhat.com"

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
ENV KUBECONFIG $GOPATH/.kube/config.json
COPY openshift-provider-cert uid_entrypoint.sh /go/ 

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" "$GOPATH/.kube" && chmod -R 0755 "$GOPATH"
RUN chown -R 1001:root /go && chown -R 1001:root /go/.kube
WORKDIR $GOPATH

USER 1001

ENTRYPOINT [ "./uid_entrypoint.sh" ]

CMD ["./openshiftopenshift-provider-cert run"]
