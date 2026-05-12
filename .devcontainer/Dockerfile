FROM mcr.microsoft.com/devcontainers/base:ubuntu AS prusaslicer-builder

# Parallelism defaults are tuned for GitHub Actions ubuntu-latest (4 vCPU / 16 GB).
# For memory-constrained local builds, override at build time:
#   docker build --build-arg DEP_JOBS=1 --build-arg DEP_THREADS=2 --build-arg BUILD_JOBS=2 .
ARG DEP_JOBS=4
ARG DEP_THREADS=4
ARG BUILD_JOBS=4

RUN apt-get update && apt-get install -y --no-install-recommends \
    cmake ninja-build build-essential git \
    m4 pkg-config python3 locales \
    libgl1-mesa-dev libxmu-dev libxi-dev \
    texinfo autoconf automake libtool

# Set UTF-8 locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

WORKDIR /tmp
RUN git clone --depth 1 --branch version_2.9.4 \
    https://github.com/prusa3d/PrusaSlicer.git

# Use GNU FTP mirror for better availability
RUN sed -i 's|https://gmplib.org/download/gmp/|https://ftp.gnu.org/gnu/gmp/|g' \
    PrusaSlicer/deps/+GMP/GMP.cmake

# Build bundled dependencies.
# wxWidgets excluded (not needed for CLI-only build).
# DEP_MAX_THREADS=2 limits per-dep parallelism to avoid OOM within container memory limits.
RUN cmake -S PrusaSlicer/deps -B PrusaSlicer/deps/build -G Ninja \
    -DPrusaSlicer_deps_PACKAGE_EXCLUDES="wxWidgets" \
    -DDEP_MAX_THREADS=${DEP_THREADS}
RUN cmake --build PrusaSlicer/deps/build -j${DEP_JOBS}

# Build CLI-only binary (no GUI).
# SLIC3R_STATIC=1 required on Linux when using bundled static deps.
RUN cmake -S PrusaSlicer -B PrusaSlicer/build -G Ninja \
    -DCMAKE_PREFIX_PATH=/tmp/PrusaSlicer/deps/build/destdir/usr/local \
    -DSLIC3R_GUI=OFF \
    -DSLIC3R_STATIC=1 \
    -DCMAKE_BUILD_TYPE=Release
RUN cmake --build PrusaSlicer/build --target prusa_slicer -j${BUILD_JOBS}


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
