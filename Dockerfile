FROM golang
ENV REPO=github.com/coreos/container-linux-config-transpiler
COPY . $GOPATH/src/$REPO
WORKDIR $GOPATH/src/$REPO
# Supply version like: docker build --build-arg VERSION="$(git describe HEAD)" .
ARG VERSION
RUN CGO_ENABLED=0 go build -o /ct -ldflags "-w -X $REPO/internal/version.Raw=$VERSION" ./cmd/ct

FROM scratch
COPY --from=0 /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=0 /ct /ct
ENTRYPOINT ["/ct"]
