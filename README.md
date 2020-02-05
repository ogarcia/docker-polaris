# Polaris docker [![CircleCI](https://circleci.com/gh/ogarcia/docker-polaris.svg?style=svg)](https://circleci.com/gh/ogarcia/docker-polaris)

(c) 2018-2020 Óscar García Amor

Redistribution, modifications and pull requests are welcomed under the terms
of GPLv3 license.

[Polaris][1] is a music streaming application, designed to let you enjoy
your music collection from any computer or mobile device.

This docker packages **Polaris** under [Alpine Linux][2], a lightweight
Linux distribution.

Visit [Docker Hub][3] or [Quay][4] to see all available tags.

[1]: https://github.com/agersant/polaris
[2]: https://alpinelinux.org/
[3]: https://hub.docker.com/r/ogarcia/polaris/
[4]: https://quay.io/repository/ogarcia/polaris

## Run

To run this container, simply exec.

```sh
docker run -t -d \
  --name=polaris \
  -p 5050:5050 \
  ogarcia/polaris
```

This start `polaris` and publish the port to host. You can go to
http://localhost:5050 to see it running.

Warning: this is a basic run, all data will be destroyed after container
stop and rm.

## Volumes

This container exports two volumes.

- /music: for store you music collection
- /var/lib/polaris: polaris data like database and logs (under
  `.local/share/polaris`)

You can exec the following to mount your music dir and store data.

```sh
docker run -t -d \
  --name=polaris \
  -p 5050:5050 \
  -v /my/music/directory:/music \
  -v /my/polaris/data:/var/lib/polaris \
  ogarcia/polaris
```

Take note that you must create before the data directory `/my/polaris/data`
and set ownership to UID/GID 100, otherwise the main proccess will crash.

```sh
mkdir -p /my/polaris/data
chown -R 100:100 /my/polaris/data
```

## Environment variables

The `run-polaris` command can use the following environment variables.

| Variable | Used for | Default value |
| --- | --- | --- |
| POLARIS_PORT | Define listen port | 5050 |
| POLARIS_CONFIG | Optional config file location | |
| POLARIS_DB | Optional database file location | |
| POLARIS_LOGLEVEL | Optional log level between 0 (off) and 3 (debug) | |

## Shell run

If you can run a shell instead `run-polaris` command, simply do.

```sh
docker run -t -i --rm \
  --name=polaris \
  -p 5050:5050 \
  -v /my/music/directory:/music \
  -v /my/polaris/data:/var/lib/polaris \
  --entrypoint=/bin/sh \
  ogarcia/polaris
```

Please note that the `--rm` modifier destroy the docker after shell exit.
