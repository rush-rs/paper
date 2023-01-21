FROM rust:alpine

WORKDIR /paper
ENV LLVM_SYS_140_PREFIX=/usr/lib/llvm14

RUN apk update
RUN apk add texlive-full

# the `biber` package in the repos is too new, so we manually donwload version 2.17 from sourceforge
# ADD https://master.dl.sourceforge.net/project/biblatex-biber/biblatex-biber/2.17/binaries/Linux-musl/biber-linux_x86_64-musl.tar.gz?viasf=1 /bin
ADD https://downloads.rubixdev.de/biber-linux_x86_64-musl.tar.gz /bin
RUN tar -xvf /bin/biber-linux_x86_64-musl.tar.gz -C /bin && \
    rm /bin/biber-linux_x86_64-musl.tar.gz

RUN apk add llvm14 llvm14-libs libc-dev g++ \
        make git jq \
        python3 py3-pip \
        tokei \
        font-jetbrains-mono-nl
RUN pip install requests

ENV RUSTFLAGS='-C target-feature=-crt-static'
