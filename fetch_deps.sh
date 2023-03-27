#!/bin/sh
# This file is used to download used git dependencies like tree-sitter parsers
# or the rush project.

set -e

mkdir -p deps

fetch_repo() {
    if ! [ -d "deps/$2" ]; then
        git clone "https://github.com/$1/$2.git" "deps/$2"
        cd "deps/$2"
    else
        cd "deps/$2"
        if [ -n "$4" ]; then
            # checkout default branch
            branch="$(git rev-parse --abbrev-ref origin/HEAD)"
            git checkout "${branch#origin/}"
        fi
        git pull
    fi

    if [ -f "../../diffs/$3" ]; then
        git apply "../../diffs/$3"
    elif [ -n "$3" ]; then
        printf "\033[1;33mWarning: patch file '$3' cannot be found\033[0m\n"
    fi

    if [ -n "$4" ]; then
        git checkout "$4"
    fi

    cd ../..
}

# tree-sitter
fetch_repo nvim-treesitter nvim-treesitter rust_macro_fix.diff &

fetch_repo tree-sitter tree-sitter-rust &
fetch_repo tree-sitter tree-sitter-bash &
fetch_repo tree-sitter tree-sitter-c &
fetch_repo RubixDev ebnf &
# fetch_repo benwilliamgraham tree-sitter-llvm &
fetch_repo RubixDev tree-sitter-llvm &
fetch_repo rush-rs tree-sitter-rush &
fetch_repo rush-rs tree-sitter-asm &
fetch_repo rush-rs tree-sitter-hexdump &
fetch_repo wasm-lsp tree-sitter-wasm &
fetch_repo rush-rs tree-sitter-wasm-queries &

# rush dependencies
fetch_repo rush-rs rush '' paper &

wait
