FROM docker.io/library/fedora:latest

ENV CC=clang

RUN dnf -y --nodocs --setopt=install_weak_deps=False install /usr/bin/{clang,curl,git,ln,tar,xz,buildbot-worker} 'dnf-command(builddep)' && \
    dnf -y --nodocs --setopt=install_weak_deps=False builddep python3 && \
    dnf -y clean all

# https://github.com/WebAssembly/wasi-sdk/releases
ENV WASI_SDK_VERSION=20
# Default path where tools will look for the WASI SDK.
ENV WASI_SDK_PATH=/opt/wasi-sdk
ENV WASI_SDK_PATH_LATEST=${WASI_SDK_PATH}-${WASI_SDK_VERSION}

RUN mkdir ${WASI_SDK_PATH_LATEST} && \
    curl --location https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-${WASI_SDK_VERSION}/wasi-sdk-${WASI_SDK_VERSION}.0-linux.tar.gz | \
    tar --strip-components 1 --directory ${WASI_SDK_PATH_LATEST} --extract --gunzip && \
    ln -s ${WASI_SDK_PATH_LATEST} ${WASI_SDK_PATH}

# https://github.com/bytecodealliance/wasmtime/releases
ENV WASMTIME_HOME=/opt/wasmtime
ENV WASMTIME_VERSION=11.0.1
ENV WASMTIME_CPU_ARCH=x86_64

RUN mkdir --parents ${WASMTIME_HOME} && \
    curl --location "https://github.com/bytecodealliance/wasmtime/releases/download/v${WASMTIME_VERSION}/wasmtime-v${WASMTIME_VERSION}-${WASMTIME_CPU_ARCH}-linux.tar.xz" | \
    xz --decompress | \
    tar --strip-components 1 --directory ${WASMTIME_HOME} -x && \
    ln -s ${WASMTIME_HOME}/wasmtime /usr/local/bin
