build: listings/generated
	rm -f main.pdf
	make main.pdf

main.pdf: main.tex listings preamble content lirstings.json
	latexmk -lualatex -shell-escape -g main.tex

init: fetch_deps.sh
	sh fetch_deps.sh
	cargo install --git https://github.com/rush-rs/lirstings --force

listings/generated: build_listings.py deps/rush listings/fib.rush listings/simple.rush listings/riscv_simple.rush
	mkdir -p ./listings/generated/
	python3 build_listings.py

clean:
	eztex c
	rm -f lirstings.cache.json
