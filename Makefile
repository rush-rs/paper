build:
	rm -f main.pdf
	make main.pdf

main.pdf: main.tex listings preamble content ts2tex.json
	latexmk -xelatex -shell-escape -g main.tex

init: fetch_deps.sh gen_config.py
	sh fetch_deps.sh
	python3 gen_config.py
	cargo install --git https://github.com/rush-rs/ts2tex
	cargo install --git https://github.com/rush-rs/ansi2tex

build_listings: build_listings.py
	python3 build_listings.py
