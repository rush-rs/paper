build:
	rm -f main.pdf
	make main.pdf

main.pdf: main.tex listings preamble content ts2tex.json
	latexmk -xelatex -shell-escape -g main.tex

config: gen_config.py
	python3 gen_config.py

tree-sitter: fetch_parsers.sh
	sh fetch_parsers.sh
