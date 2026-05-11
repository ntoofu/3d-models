FROM mcr.microsoft.com/devcontainers/base:ubuntu AS prusaslicer-builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    cmake ninja-build build-essential git \
    m4 pkg-config python3

WORKDIR /tmp
RUN git clone --depth 1 --branch version_2.9.4 \
    https://github.com/prusa3d/PrusaSlicer.git

# Build bundled dependencies. Skip wxWidgets (not needed for CLI-only build).
RUN cmake -S PrusaSlicer/deps -B PrusaSlicer/deps/build -G Ninja \
    -DDEP_WX_GTK3=OFF
RUN cmake --build PrusaSlicer/deps/build -j$(nproc)

# Build CLI-only binary (no GUI, no OpenGL)
RUN cmake -S PrusaSlicer -B PrusaSlicer/build -G Ninja \
    -DCMAKE_PREFIX_PATH=/tmp/PrusaSlicer/deps/build/destdir/usr/local \
    -DSLIC3R_GUI=OFF \
    -DCMAKE_BUILD_TYPE=Release
RUN cmake --build PrusaSlicer/build --target prusa_slicer -j$(nproc)


FROM mcr.microsoft.com/devcontainers/base:ubuntu

# This image includes binaries from the following open-source projects:
#
#   PrusaSlicer  — AGPL-3.0  — https://github.com/prusa3d/PrusaSlicer
#   OpenSCAD     — GPL-2.0   — https://github.com/openscad/openscad
#   BOSL2        — BSD-2-Clause — https://github.com/BelfrySCAD/BOSL2
#
# Redistribution is permitted under each license. Source code is available
# at the URLs above.

LABEL org.opencontainers.image.licenses="AGPL-3.0 AND GPL-2.0 AND BSD-2-Clause"
LABEL org.opencontainers.image.description="OpenSCAD + PrusaSlicer CLI devcontainer"

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends openscad git make \
    && rm -rf /var/lib/apt/lists/*

COPY --from=prusaslicer-builder /tmp/PrusaSlicer/build/src/prusa-slicer /usr/local/bin/prusa-slicer

USER vscode
RUN mkdir -p /home/vscode/.local/share/OpenSCAD/libraries \
    && git clone https://github.com/BelfrySCAD/BOSL2.git /home/vscode/.local/share/OpenSCAD/libraries/BOSL2
