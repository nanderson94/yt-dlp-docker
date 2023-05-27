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
#   * ffmpeg - Build from source
#   * AtompicParsely - Omitted for now
#   * xattr - Omitted for now
#   * certifi - Not required, existing CA is fine
#   * secretstorage - Omitted, this container shouldn't have access to keyring
###

FROM alpine:latest AS base

RUN apk update && apk upgrade
RUN apk --no-cache add \
    python3 \
    py3-pip \
    fontconfig \
    ffmpeg

#FROM base AS ffmpeg_builder
#WORKDIR /opt/yt-dlp-ffmpeg/
#COPY yt-dlp-ffmpeg/ .
#COPY ffmpeg-source/ ffmpeg
#
#WORKDIR /opt/yt-dlp-ffmpeg/ffmpeg
#RUN apk --no-cache add \
#    git \
#    build-base \
#    yasm \
#    libass-dev \
#    freetype-dev \
#    openssl-dev \
#    lame-dev \
#    sdl2-dev \
#    libtool \
#    libva-dev \
#    libva-vdpau-driver \
#    libvdpau-dev \
#    libvorbis-dev \
#    xcb-util-dev \
#    xcb-proto \
#    xcb-imdkit-dev \
#    texinfo \
#    wget \
#    zlib-dev \
#    nasm \
#    x264-dev \
#    x265-dev \
#    libvpx-dev \
#    fdk-aac-dev \
#    dav1d-dev \
#    svt-av1-dev

#RUN for patch in /opt/yt-dlp-ffmpeg/patches/ffmpeg/master/*.patch; do \
#        git apply $patch; \
#    done
#RUN mkdir -p /opt/ffbuild/prefix
#RUN ./configure --prefix=/opt/ffbuild/prefix \
#                --pkg-config-flags="--static" \
#                --enable-gpl \
#                --enable-version3 \
#                --disable-debug \
#                --enable-libopus \
#                --enable-nonfree \
#                --enable-libfdk-aac \
#                --enable-libvpx \
#                --enable-libx265 \
#                --enable-libx264 \
#                --enable-libdav1d \
#                --enable-libsvtav1 \
#                --enable-libfreetype \
#                --enable-libmp3lame \
#                --enable-openssl \
#                --enable-libass
#RUN make -j$(nproc) V=1
#RUN make install install-doc

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

FROM base
RUN pip install yt-dlp
#COPY --from=ffmpeg_builder /opt/ffbuild/prefix/bin /usr/bin
#COPY --from=ffmpeg_builder /opt/ffbuild/prefix/lib /usr/lib
#COPY --from=ffmpeg_builder /opt/ffbuild/prefix/share /usr/share
#COPY --from=ffmpeg_builder /opt/ffbuild/prefix/include /usr/include
#COPY --from=phantomjs_builder /opt/phantomjs/phantomjs-git/ /opt/phantomjs

ENTRYPOINT /usr/bin/yt-dlp
