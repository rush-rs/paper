#!/bin/sh
# This file is used to download all used tree-sitter parsers into the `tree-sitter` subdirectory.

set -e

mkdir -p tree-sitter

fetch_repo () {
    if ! [ -d "tree-sitter/$2" ]; then
        git clone "https://github.com/$1/$2.git" "tree-sitter/$2"
    else
        cd "tree-sitter/$2"
        git pull
        cd ../..
    fi
}

fetch_repo nvim-treesitter nvim-treesitter
fetch_repo tree-sitter tree-sitter-rust
fetch_repo RubixDev ebnf
# fetch_repo benwilliamgraham tree-sitter-llvm
fetch_repo RubixDev tree-sitter-llvm
fetch_repo rush-rs tree-sitter-rush
