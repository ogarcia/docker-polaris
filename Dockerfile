ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION} AS builder
ARG POLARIS_VERSION
COPY .circleci /polaris/build
ADD https://github.com/agersant/polaris/releases/download/${POLARIS_VERSION}/Polaris_${POLARIS_VERSION}.tar.gz /polaris/src/polaris.tar.gz
RUN /polaris/build/build.sh

FROM alpine:${ALPINE_VERSION}
RUN apk -U --no-progress upgrade && \
    apk --no-progress add libgcc sqlite-libs && \
    install -d -m0755 -o100 -g100 /var/cache/polaris && \
    install -d -m0755 -o100 -g100 /var/lib/polaris && \
    install -d -m0755 -o100 -g100 /var/log/polaris && \
    rm -f /var/cache/apk/*
COPY --from=builder /polaris/pkg /
EXPOSE 5050
VOLUME [ "/music", "/var/cache/polaris", "/var/lib/polaris" ]
USER polaris
ENTRYPOINT [ "/bin/run-polaris" ]
