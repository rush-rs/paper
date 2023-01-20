build: listings/generated
	rm -f main.pdf
	make main.pdf

main.pdf: main.tex listings preamble content ts2tex.json
	latexmk -lualatex -shell-escape -g main.tex

init: fetch_deps.sh gen_config.py
	sh fetch_deps.sh
	python3 gen_config.py
	cargo install --git https://github.com/rush-rs/ts2tex

listings/generated: build_listings.py deps/rush listings/fib.rush listings/simple.rush
	mkdir -p ./listings/generated/
	python3 build_listings.py
