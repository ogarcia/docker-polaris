FROM alpine:3.8

COPY scripts /tmp/scripts

ADD https://github.com/agersant/polaris/releases/download/v0.8.0/polaris-0.8.0.tar.gz /tmp/build/polaris.tar.gz

RUN /tmp/scripts/build.sh

EXPOSE 5050

VOLUME [ "/music", "/var/lib/polaris" ]

USER polaris

ENTRYPOINT [ "/usr/bin/run-polaris" ]
