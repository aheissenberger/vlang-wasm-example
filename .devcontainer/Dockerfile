# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.177.0/containers/debian/.devcontainer/base.Dockerfile

# [Choice] Debian version: buster, stretch
ARG VARIANT="buster"
ARG WASI_SDK_VERSION="12"
ARG WASI_SDK_SUB_VERSION="0"

FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT} as base

# ** [Optional] Uncomment this section to install additional packages. **
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        clang make

FROM base as vlang_builder
RUN export DEBIAN_FRONTEND=noninteractive && apt-get -y install --no-install-recommends \
        libssl-dev libsqlite3-dev
RUN mkdir -p /vlang/src && \
    git clone https://github.com/vlang/v /vlang/src && \
    cd /vlang/src && \
    make
    # for f in /vlang/src/cmd/tools/*.v; do /vlang/src/v "$f" && rm "$f"; done && \
    # for f in /vlang/src/cmd/tools/*/; do /vlang/src/v "$f" ; done

FROM base as vlang
RUN mkdir -p /opt/vlang
COPY --from=vlang_builder /vlang/src/v /opt/vlang/v
COPY --from=vlang_builder /vlang/src/cmd /opt/vlang/cmd
COPY --from=vlang_builder /vlang/src/vlib /opt/vlang/vlib
COPY --from=vlang_builder /vlang/src/thirdparty /opt/vlang/thirdparty
COPY --from=vlang_builder /vlang/src/v.mod /opt/vlang/v.mod
COPY --from=vlang_builder /vlang/src/LICENSE /opt/vlang/LICENSE
RUN ln -s /opt/vlang/v /usr/local/bin/v && \
    # vlang need write access to vlang root directory :-(
    chown -R root:vscode /opt/vlang && \
    chmod -R g+w /opt/vlang

# WASM requirements
FROM vlang as wasi
ARG WASI_SDK_VERSION
ARG WASI_SDK_SUB_VERSION

RUN echo "deb http://deb.debian.org/debian buster-backports main" >> /etc/apt/sources.list && \
    apt-get update && export DEBIAN_FRONTEND=noninteractive &&\
    apt-get -y install --no-install-recommends \
        xz-utils lldb-11

RUN mkdir -p /opt/wasi-sdk && \
    curl -L https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-${WASI_SDK_VERSION}/wasi-sdk-${WASI_SDK_VERSION}.${WASI_SDK_SUB_VERSION}-linux.tar.gz | tar -xz --strip-components=1 -C /opt/wasi-sdk
ENV WASI_SDK="/opt/wasi-sdk"
RUN curl https://wasmtime.dev/install.sh -sSf | bash && \
    mv /root/.wasmtime /opt/wasmtime && \
    ln -s /opt/wasmtime/bin/wasmtime /usr/local/bin/wasmtime
# &&\
#     mv ~/.wasmtime /home/vscode/.wasmtime