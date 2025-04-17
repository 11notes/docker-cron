![banner](https://github.com/11notes/defaults/blob/main/static/img/banner.png?raw=true)

# ⛰️ cron
[<img src="https://img.shields.io/badge/github-source-blue?logo=github&color=040308">](https://github.com/11notes/docker-cron)![size](https://img.shields.io/docker/image-size/11notes/cron/4.6?color=0eb305)![version](https://img.shields.io/docker/v/11notes/cron/4.6?color=eb7a09)![pulls](https://img.shields.io/docker/pulls/11notes/cron?color=2b75d6)[<img src="https://img.shields.io/github/issues/11notes/docker-cron?color=7842f5">](https://github.com/11notes/docker-cron/issues)

rootless cron scheduler with cmd-socket command

# MAIN TAGS 🏷️
These are the main tags for the image. There is also a tag for each commit and its shorthand sha256 value.

* [4.6](https://hub.docker.com/r/11notes/cron/tags?name=4.6)
* [stable](https://hub.docker.com/r/11notes/cron/tags?name=stable)
* [latest](https://hub.docker.com/r/11notes/cron/tags?name=latest)

# SYNOPSIS 📖
**What can I do with this?** This image will give you the ability to execute cron jobs in a complete rootless environment. It also contains the ```cmd``` command to execute commands inside other images that use the [cmd-socket](https://github.com/11notes/go-cmd-socket) binary.

# COMPOSE ✂️
```yaml
name: "cron"
services:
  cron:
    image: "11notes/cron:4.6"
    container_name: "cron"
    environment:
      TZ: "Europe/Zurich"
      CRONTAB: |-
        * * * * * eleven log info "I run every minute" > /proc/1/fd/1
        0 3 * * * cmd /run/cmd/.sock backup > /proc/1/fd/1
    restart: "always"
```

# DEFAULT SETTINGS 🗃️
| Parameter | Value | Description |
| --- | --- | --- |
| `user` | docker | user name |
| `uid` | 1000 | [user identifier](https://en.wikipedia.org/wiki/User_identifier) |
| `gid` | 1000 | [group identifier](https://en.wikipedia.org/wiki/Group_identifier) |
| `home` | /cron | home directory of user docker |

# ENVIRONMENT 📝
| Parameter | Value | Default |
| --- | --- | --- |
| `TZ` | [Time Zone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) | |
| `DEBUG` | Will activate debug option for container image and app (if available) | |

# SOURCE 💾
* [11notes/cron](https://github.com/11notes/docker-cron)

# PARENT IMAGE 🏛️
* [11notes/alpine:stable](https://hub.docker.com/r/11notes/alpine)

# BUILT WITH 🧰
* [dcron](https://github.com/ptchinster/dcron)
* [cmd-socket](https://github.com/11notes/go-cmd-socket)

# GENERAL TIPS 📌
* Use a reverse proxy like Traefik, Nginx, HAproxy to terminate TLS and to protect your endpoints
* Use Let’s Encrypt DNS-01 challenge to obtain valid SSL certificates for your services

# ElevenNotes™️
This image is provided to you at your own risk. Always make backups before updating an image to a different version. Check the [releases](https://github.com/11notes/docker-cron/releases) for breaking changes. If you have any problems with using this image simply raise an [issue](https://github.com/11notes/docker-cron/issues), thanks. If you have a question or inputs please create a new [discussion](https://github.com/11notes/docker-cron/discussions) instead of an issue. You can find all my other repositories on [github](https://github.com/11notes?tab=repositories).

*created 12.3.2025, 08:52:45 (CET)*