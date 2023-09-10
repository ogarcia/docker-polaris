ARG ALPINE_VERSION=3.18
ARG POLARIS_VERSION=0.14.0
ARG USER=1000
ARG GROUP=1000

FROM alpine:${ALPINE_VERSION} AS builder
COPY .circleci /polaris/build
ARG POLARIS_VERSION
ADD https://github.com/agersant/polaris/releases/download/${POLARIS_VERSION}/Polaris_${POLARIS_VERSION}.tar.gz /polaris/src/polaris.tar.gz
RUN /polaris/build/build.sh

FROM alpine:${ALPINE_VERSION}
ARG USER
ARG GROUP
RUN apk -U --no-progress upgrade && \
    apk --no-progress add libgcc sqlite-libs && \
    install -d -m0755 -o${USER} -g${GROUP} /var/cache/polaris && \
    install -d -m0755 -o${USER} -g${GROUP} /var/lib/polaris && \
    install -d -m0755 -o${USER} -g${GROUP} /var/log/polaris && \
    rm -f /var/cache/apk/*
COPY --from=builder /polaris/pkg /
EXPOSE 5050
VOLUME [ "/music", "/var/cache/polaris", "/var/lib/polaris" ]
USER polaris
ENTRYPOINT [ "/bin/run-polaris" ]
