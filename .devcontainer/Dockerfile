FROM mcr.microsoft.com/devcontainers/base:ubuntu AS curaengine-builder
RUN apt-get update && apt-get install -y --no-install-recommends wget ca-certificates
WORKDIR /tmp
RUN wget -q "https://github.com/Ultimaker/Cura/releases/download/5.12.0/UltiMaker-Cura-5.12.0-linux-X64.AppImage" \
        -O Cura.AppImage \
    && chmod +x Cura.AppImage \
    && ./Cura.AppImage --appimage-extract \
    && rm Cura.AppImage


FROM mcr.microsoft.com/devcontainers/base:ubuntu
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends openscad git make \
    && rm -rf /var/lib/apt/lists/*

# CuraEngine binary + bundled libs extracted from AppImage
COPY --from=curaengine-builder /tmp/squashfs-root/ /opt/curaengine/
# CuraEngine uses a relative ELF interpreter (lib64/ld-linux-x86-64.so.2),
# so invoke it via the system linker to avoid "required file not found".
RUN printf '#!/bin/sh\nexport LD_LIBRARY_PATH=/opt/curaengine${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}\nexec /lib64/ld-linux-x86-64.so.2 /opt/curaengine/CuraEngine "$@"\n' \
    > /usr/local/bin/CuraEngine \
    && chmod +x /usr/local/bin/CuraEngine

USER vscode
RUN mkdir -p /home/vscode/.local/share/OpenSCAD/libraries \
    && git clone https://github.com/BelfrySCAD/BOSL2.git /home/vscode/.local/share/OpenSCAD/libraries/BOSL2
