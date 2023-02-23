LATEXMK ?= latexmk

.PHONY: all
all : main.pdf

main.pdf : *.tex
	$(LATEXMK) main.tex
	mv build/main.pdf main.pdf

.PHONY : clean
clean :
	rm -rf build
	rm -f *.pdf
