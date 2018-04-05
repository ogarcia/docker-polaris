FROM alpine:3.7

COPY scripts /tmp/scripts

ADD https://github.com/agersant/polaris/releases/download/v0.7.1/polaris-0.7.1.tar.gz /tmp/build/polaris.tar.gz

RUN /tmp/scripts/build.sh

EXPOSE 5050

VOLUME [ "/music", "/var/lib/polaris" ]

USER polaris

ENTRYPOINT [ "/usr/bin/run-polaris" ]
