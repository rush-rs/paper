build:
	rm -f main.pdf
	make main.pdf

main.pdf: main.tex listings preamble content ts2tex.json
	latexmk -xelatex -shell-escape -g main.tex

init: fetch_deps.sh gen_config.py
	sh fetch_deps.sh
	python3 gen_config.py
