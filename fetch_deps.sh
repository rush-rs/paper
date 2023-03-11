#!/bin/sh
# This file is used to download used git dependencies like tree-sitter parsers or the rush project.

set -e

mkdir -p deps

install_pacman() {
    if [ -x "$(command -v pacman)" ]; then
        if pacman -Qs "$1" > /dev/null; then
            echo "Pacman: $1 is installed"
        else
            echo "Pacman: $1 is not installed: installing..."
            sudo pacman -S "$1" --noconfirm
        fi
    else
        echo "Pacman: command not fount, please install '$1' manually"
    fi
}

fetch_repo() {
    if ! [ -d "deps/$2" ]; then
        git clone "https://github.com/$1/$2.git" "deps/$2"
    else
        cd "deps/$2"
        git pull
        cd ../..
    fi
}

# Pacman packages
install_pacman perl-image-exiftool

# tree-sitter
fetch_repo nvim-treesitter nvim-treesitter

fetch_repo tree-sitter tree-sitter-rust
fetch_repo tree-sitter tree-sitter-bash
fetch_repo tree-sitter tree-sitter-c
fetch_repo RubixDev ebnf
# fetch_repo benwilliamgraham tree-sitter-llvm
fetch_repo RubixDev tree-sitter-llvm
fetch_repo rush-rs tree-sitter-rush
fetch_repo rush-rs tree-sitter-asm
fetch_repo rush-rs tree-sitter-hexdump
fetch_repo wasm-lsp tree-sitter-wasm
fetch_repo rush-rs tree-sitter-wasm-queries

# rush dependencies
fetch_repo rush-rs rush

wait
