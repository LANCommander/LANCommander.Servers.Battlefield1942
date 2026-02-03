# syntax=docker/dockerfile:1.7

FROM lancommander/base:latest

ENV BF1942_SERVER_URL="https://github.com/LANCommander/LANCommander.Server.Battlefield1942/releases/download/v1.61/bf1942_lnxded-1.61.zip"

ENV START_EXE="./bf1942_lnxded"
ENV START_ARGS="+statusMonitor 1"

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

EXPOSE 14567/udp
EXPOSE 4711/tcp
EXPOSE 22000/udp
EXPOSE 27900/tcp

# COPY Modules/ "${BASE_MODULES}/"
COPY Hooks/ "${BASE_HOOKS}/"

WORKDIR /config
ENTRYPOINT ["/usr/local/bin/entrypoint.ps1"]