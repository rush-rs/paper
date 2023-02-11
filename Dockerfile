FROM rust:alpine

WORKDIR /paper
ENV LLVM_SYS_140_PREFIX=/usr/lib/llvm14

# to remove the cache at the end, all apk installs must happen in one step,
# see https://github.com/gliderlabs/docker-alpine/issues/45
RUN apk add --update \
        texlive \
        texlive-luatex \
        xdvik texlive-dvi \
        texmf-dist \
        texmf-dist-bibtexextra \
        texmf-dist-formatsextra \
        texmf-dist-latexextra \
        texmf-dist-science \
        \
        llvm14 llvm14-libs llvm14-dev llvm14-static \
        libc-dev libxml2-dev libffi-dev g++ \
        make git jq rsync nodejs \
        python3 \
        tokei \
        exiftool \
        font-jetbrains-mono-nl && \
    rm -rf /var/cache/apk/*

# the `biber` package in the repos is too new, so we manually download version 2.17 from sourceforge
# RUN wget -O- https://master.dl.sourceforge.net/project/biblatex-biber/biblatex-biber/2.17/binaries/Linux-musl/biber-linux_x86_64-musl.tar.gz?viasf=1 | tar xzv -C /bin
RUN wget -O- https://downloads.rubixdev.de/biber-linux_x86_64-musl.tar.gz | tar xzv -C /bin

ENV RUSTFLAGS='-C target-feature=-crt-static'
ENV CARGO_TARGET_DIR=/root/.cache/cargo
