###
# Designed around ConcourseCI's checkout style. To build, you'll need the
# following paths present, relative to this Dockerfile:
#   * ../yt-dlp-source/ - A git clone of the yt-dlp/yt-dlp repository
#   * ../yt-dlp-ffpmeg/ - A git clone of the yt-dlp/FFmpeg-Builds repository
#   * ../yt-dlp-docker/ - This repository
#
# The following build arguments are considered:
#   * ytdlp_version = source -- This should be set when building from tag
#   * 
#
# Dependencies built:
#   * brotli - Installed via Python
#   * mutagen - Installed via Python
#   * websockets - Install via Python
#   * pycryptodomeex - Install via Python
#   * phantomjs - Build from source - Someday
#   * ffmpeg - Installed via apk
#   * AtompicParsely - Omitted for now
#   * xattr - Omitted for now
#   * certifi - Not required, existing CA is fine
#   * secretstorage - Omitted, this container shouldn't have access to keyring
###

FROM quay.io/fedora/fedora:latest AS base

LABEL org.opencontainers.image.authors='Nic A <docker@nic-a.net>' \
      org.opencontainers.image.url='https://github.com/nanderson94/yt-dlp-docker' \
      org.opencontainers.image.documentation='https://github.com/nanderson94/yt-dlp-docker' \
      org.opencontainers.image.vendor='Nandernet' \
      org.opencontainers.image.source='https://github.com/nanderson94/yt-dlp-docker' \
      org.opencontainers.image.licenses='Apache-2.0'

RUN dnf -y update && \
    dnf -y install \
    python3-pip \
    fontconfig \
    awscli \
    ffmpeg-free && \
    dnf clean all

# PhantomJS is frozen on development, pull from source within container
#FROM base AS phantomjs_builder
#ARG phantomjs_version=2.1.1
#WORKDIR /opt/phantomjs/
#RUN apk add --no-cache \
#    build-base \
#    git \
#    curl \
#    tar \
#    g++ \
#    bison \
#    flex \
#    gperf \
#    perl \
#    ruby \
#    sqlite \
#    freetype \
#    openssl \
#    libpng \
#    libjpeg \
#    icu \
#    icu-dev \
#    openssl-dev \
#    linux-headers
#
## Get and extract source
## Visions of curl were quickly met with sadness as submodules aren't included
#RUN git clone --depth 1 --branch $phantomjs_version --recurse-submodules --shallow-submodules https://github.com/ariya/phantomjs.git phantomjs-git
#WORKDIR /opt/phantomjs/phantomjs-git
#
#RUN python3 build.py --confirm --release

FROM base AS ytdlp_builder
ARG YTDLP_SOURCE=/yt-dlp-source
COPY $YTDLP_SOURCE /opt/yt-dlp
WORKDIR /opt/yt-dlp
RUN dnf -y install "@Development Tools" pandoc && \
    dnf clean all
RUN pip install -r requirements.txt \
    && make

FROM base
COPY --from=ytdlp_builder /opt/yt-dlp/yt-dlp /usr/bin/yt-dlp
#COPY --from=ffmpeg_builder /opt/ffbuild/prefix/bin /usr/bin
#COPY --from=ffmpeg_builder /opt/ffbuild/prefix/lib /usr/lib
#COPY --from=ffmpeg_builder /opt/ffbuild/prefix/share /usr/share
#COPY --from=ffmpeg_builder /opt/ffbuild/prefix/include /usr/include
#COPY --from=phantomjs_builder /opt/phantomjs/phantomjs-git/ /opt/phantomjs

#ENTRYPOINT /usr/bin/yt-dlp
