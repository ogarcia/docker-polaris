# Polaris container

**This project is no longer maintained and will not receive further updates.**

(c) 2018-2026 [Connectical] Óscar García Amor

For years this repository packaged [Polaris][po] under [Alpine Linux][al]. It
has been retired: no new images will be built, neither for new Polaris
releases nor for new Alpine base images. The images already published on
[Quay][qu] and [GitLab][gl] stay where they are, but they will not get any
security fixes.

The last state of the repository, with the `Containerfile` and the full
documentation, is kept in the [`archive`][ar] branch for anybody who wants to
keep building it on their own.

[po]: https://github.com/agersant/polaris
[al]: https://alpinelinux.org/
[qu]: https://quay.io/repository/connectical/polaris
[gl]: https://gitlab.com/connectical/container/polaris/container_registry
[ar]: https://gitlab.com/connectical/container/polaris/-/tree/archive

## Migrate to Tocata

The recommended replacement is [Tocata][to], an [OpenSubsonic][os] compatible
music server written in Rust. Its presentation page, with screenshots of the
panel, is at [tocata.ogarcia.me][tw].

What you get compared to Polaris:

- **Any OpenSubsonic player.** Tocata speaks the OpenSubsonic API, so you are
  not tied to one web client and one mobile app: the whole ecosystem of
  Subsonic and OpenSubsonic players, on desktop and mobile, works with it.
- **One static binary.** The server and its administration panel ship in a
  single binary, statically linked against musl. Nothing to install beside it,
  no runtime and no web server in front of it. There is no need for a custom
  container like this one: an official image is published by the project.
- **Light.** It indexes a collection of almost twelve thousand songs and plays
  them in around twenty megabytes of memory.
- **Collections and access.** Several collections, each reachable by the
  people you choose, managed from the panel. Your music is mounted read only:
  Tocata never writes to it.
- **Careful authentication.** Passwords stored as Argon2id hashes, panel
  sessions that can be listed and closed one by one, and per-client API keys
  (`apiKeyAuthentication` extension) that can be revoked individually.
- **More from your files.** Timed lyrics (`songLyrics`), cover art read from
  the files themselves, every tag a file carries, top songs by artist and play
  counts across everybody who listens on the server.

[to]: https://github.com/ogarcia/tocata
[os]: https://opensubsonic.netlify.app/
[tw]: https://tocata.ogarcia.me/

### Quick start

```sh
alias docker="podman" # If you are using podman
docker run -d --name tocata \
  -p 4224:4224 \
  -v tocata-data:/data \
  -v /my/music/directory:/media:ro \
  ghcr.io/ogarcia/tocata:latest
```

On the first run Tocata creates an `admin` account and writes its generated
password to the log, once. The panel is then at http://localhost:4224/, where
you add `/media` (or a directory inside it) as a collection and start the
first scan. Point your player at the same address, using an API key or the
player's plain (legacy) password authentication: token authentication is
refused on purpose, since it cannot coexist with hashed passwords.

Nothing is carried over from Polaris: Tocata builds its own catalogue from
the music files, so the only thing you need to keep is the music directory.
Your Polaris data and cache volumes can be removed once you have moved.

Everything else, from prebuilt binaries to environment variables and
authentication details, is in the [Tocata README][tr].

[tr]: https://github.com/ogarcia/tocata#readme
