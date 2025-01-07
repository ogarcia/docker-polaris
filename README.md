# Polaris container

[![forthebadge](https://forthebadge.com/images/badges/powered-by-flux-capacitor.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/compatibility-betamax.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/does-not-contain-treenuts.svg)](https://forthebadge.com)

(c) 2018-2025 [Connectical] Óscar García Amor

Redistribution, modifications and pull requests are welcomed under the terms
of GPLv3 license.

[Polaris][po] is a music streaming application, designed to let you enjoy
your music collection from any computer or mobile device.

This container packages **Polaris** under [Alpine Linux][al], a lightweight
Linux distribution.

Visit [Quay][qu] or [GitLab][gl] to see all available tags.

[po]: https://github.com/agersant/polaris
[al]: https://alpinelinux.org/
[qu]: https://quay.io/repository/connectical/polaris
[gl]: https://gitlab.com/connectical/container/polaris/container_registry

## Run

To run this container, simply exec.

```sh
alias docker="podman" # If you are using podman
docker run -t -d \
  --name=polaris \
  -p 5050:5050 \
  registry.gitlab.com/connectical/container/polaris
```

This start `polaris` and publish the port to host. You can go to
http://localhost:5050 to see it running.

Warning: this is a basic run, all data will be destroyed after container
stop and rm.

## Volumes

This container exports three volumes.

- /music: for store you music collection
- /var/cache/polaris: polaris cache
- /var/lib/polaris: polaris data like database

You can exec the following to mount your music dir, store cache and data.

```sh
alias docker="podman" # If you are using podman
docker run -t -d \
  --name=polaris \
  -p 5050:5050 \
  -v /my/music/directory:/music \
  -v /my/polaris/cache:/var/cache/polaris \
  -v /my/polaris/data:/var/lib/polaris \
  registry.gitlab.com/connectical/container/polaris
```

Take note that you must create before the cache directory
`/my/polaris/cache` and data directory `/my/polaris/data` and set ownership
to UID/GID 100 in both, otherwise the main proccess will crash.

```sh
mkdir -p /my/polaris/cache /my/polaris/data
chown -R 100:100 /my/polaris/cache /my/polaris/data
```

**WARNING**: Breaking changes in 0.13.x. The database is stored by default
in `/var/lib/polaris/db.sqlite`. You must move your database from
`/my/polaris/data/.local/share/polaris` to `/my/polaris/data`. The cache
files are stored now in `/var/cache/polaris`.

## Environment variables

The `run-polaris` command can use the following environment variables.

| Variable | Used for | Default value |
| --- | --- | --- |
| POLARIS_PORT | Define listen port | 5050 |
| POLARIS_CONFIG | Optional config file location | |
| POLARIS_DB | Optional database file location | |
| POLARIS_CACHE_DIR | Optional cache directory location | /var/cache/polaris |
| POLARIS_PIDFILE | Optional pid file location (see note) | |
| POLARIS_LOGFILE | Optional log file location (see note) | |
| POLARIS_LOGLEVEL | Optional log level between 0 (off) and 3 (debug) | |
| POLARIS_DAEMONIZE | Run polaris as daemon in container (see note) | false |

Note: both `POLARIS_PIDFILE` and `POLARIS_LOGFILE` only apply if you set
`POLARIS_DAEMONIZE` as `true`. This only have sense if you want use this
image as base of your own modified one and you want run anything else.

## Shell run

If you want to run a shell instead `run-polaris` command, simply do.

```sh
alias docker="podman" # If you are using podman
docker run -t -i --rm \
  --name=polaris \
  -p 5050:5050 \
  -v /my/music/directory:/music \
  -v /my/polaris/data:/var/lib/polaris \
  --entrypoint=/bin/sh \
  registry.gitlab.com/connectical/container/polaris
```

Please note that the `--rm` modifier destroy the container after shell exit.
