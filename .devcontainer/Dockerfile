FROM mcr.microsoft.com/devcontainers/base:ubuntu

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends software-properties-common \
    && add-apt-repository ppa:openscad/snapshots \
    && apt-get update \
    && apt-get -y install --no-install-recommends openscad curaengine git make \
    && rm -rf /var/lib/apt/lists/*

USER vscode
RUN mkdir -p /home/vscode/.local/share/OpenSCAD/libraries \
    && git clone https://github.com/BelfrySCAD/BOSL2.git /home/vscode/.local/share/OpenSCAD/libraries/BOSL2
