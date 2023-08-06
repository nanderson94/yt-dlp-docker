# yt-dlp-docker
Dockerfile + CI for an always fresh yt-dlp image.

[![CI](https://ci.nic-a.net/api/v1/teams/main/pipelines/docker-yt-dlp/badge)](https://ci.nic-a.net/teams/main/pipelines/docker-yt-dlp)
[![Docker Repository on Quay](https://quay.io/repository/nandernet/yt-dlp/status "Docker Repository on Quay")](https://quay.io/repository/nandernet/yt-dlp)

Using Concourse CI's declarative resources as triggers for continuously
building fresh images from upstream sources. Docker tags are based on the
upstream `yt-dlp` repository, with the exception of `unstable` which tracks
the upstream `master` branch.

Images are published to GitHub, Quay, and DockerHub.

