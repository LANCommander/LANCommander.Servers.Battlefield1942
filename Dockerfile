# syntax=docker/dockerfile:1.7

FROM lancommander/base:latest

ENV BF1942_SERVER_URL="https://github.com/LANCommander/LANCommander.Servers.Battlefield1942/releases/download/v1.61/bf1942_lnxded-1.61.zip"

ENV START_EXE="./bf1942_lnxded"
ENV START_ARGS="+statusMonitor 1"

USER root

# ----------------------------
# Dependencies
# ----------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    bzip2 \
    tar \
    unzip \
    xz-utils \
    p7zip-full \
    gosu

RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get install -y --no-install-recommends \
        libc6:i386 \
        libgcc-s1:i386 \
        libstdc++6:i386 \
        libstdc++5:i386 \
        libncurses5:i386

EXPOSE 14567/udp
EXPOSE 4711/tcp
EXPOSE 22000/udp
EXPOSE 27900/tcp

# COPY Modules/ "${BASE_MODULES}/"
COPY Hooks/ "${BASE_HOOKS}/"

USER lancommander

WORKDIR /config
ENTRYPOINT ["/usr/local/bin/entrypoint.ps1"]