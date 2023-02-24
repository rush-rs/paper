build: listings/generated
	rm -f main.pdf
	make main.pdf
	make exif

main.pdf: main.tex listings preamble content lirstings.json
	latexmk -lualatex -shell-escape -g main.tex

exif:
	exiftool \
		-Title="The Conversion of Source Code to Machine Code" \
		-Author="Silas Groh, Mik Müller" \
		-Subject="Compiler Construction" \
		-Keywords="compiler, compiler construction, programming language" \
		-overwrite_original \
		main.pdf

init: fetch_deps.sh
	sh fetch_deps.sh
	cargo install --git https://github.com/rush-rs/lirstings --force

listings/generated: rush_build.py deps/rush listings/fib.rush listings/simple.rush listings/riscv_simple.rush listings/rush_simple_pointer.rush listings/simple_add.rush listings/while_loop.rush
	mkdir -p ./listings/generated/
	python3 rush_build.py build

# Ensures that all `.rush` are semantically valid
# Checks compatibility between `.rush` code and rush source
check_rush: rush_build.py listings deps
	mkdir -p ./listings/generated/
	python3 rush_build.py check

clean:
	eztex c
	rm -f lirstings.cache.json

contributors: CONTRIBUTORS.tex
	latexmk -lualatex -g CONTRIBUTORS.tex
	exiftool \
		-Title="Contributors: The Conversion of Source Code to Machine Code" \
		-Author="Silas Groh, Mik Müller" \
		-Subject="Compiler Construction" \
		-Keywords="compiler, compiler construction, programming language" \
		-overwrite_original \
		CONTRIBUTORS.pdf
