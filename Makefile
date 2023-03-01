LATEXMK ?= latexmk

.PHONY: all
all : main.pdf supplement.pdf

main.pdf : *.tex
	$(LATEXMK) main.tex
	mv build/main.pdf main.pdf

supplement.pdf : *.tex
	$(LATEXMK) supplement.tex
	mv build/supplement.pdf supplement.pdf

.PHONY : clean
clean :
	rm -rf build
	rm -f *.pdf
