FROM alpine:3.11 AS builder
COPY scripts /polaris/scripts
ADD https://github.com/agersant/polaris/releases/download/v0.11.0/polaris-0.11.0.tar.gz /polaris/src/polaris.tar.gz
RUN /polaris/scripts/build.sh

FROM alpine:3.11
RUN apk -U --no-progress upgrade && \
    apk --no-progress add libgcc sqlite-libs && \
    install -d -m0755 -o100 -g100 /var/lib/polaris
COPY --from=builder /polaris/pkg /
EXPOSE 5050
VOLUME [ "/music", "/var/lib/polaris" ]
USER polaris
ENTRYPOINT [ "/bin/run-polaris" ]
