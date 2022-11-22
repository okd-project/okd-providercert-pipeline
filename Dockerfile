FROM registry.access.redhat.com/ubi9/ubi-minimal:latest

LABEL maintainer="luzuccar@redhat.com"

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
ENV KUBECONFIG /config/.kube/config.json
COPY uid_entrypoint.sh  openshift-provider-cert /go/ 
 
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" "/config" "/data" && chmod -R 0755 "$GOPATH"  && chmod -R 0755 "/config" && chmod -R 0755 "/data"

RUN chown -R 1001:root /go && chown -R 1001:root /config && chown -R 1001:root /data 
WORKDIR $GOPATH

USER 1001

ENTRYPOINT [ "./uid_entrypoint.sh" ]

CMD ["./openshift-provider-cert","run"]
