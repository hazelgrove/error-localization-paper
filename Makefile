LATEXMK ?= latexmk

.PHONY: all
all : main.pdf sources.zip supplement.pdf

main.pdf : *.tex
	$(LATEXMK) main.tex
	mv build/main.pdf main.pdf

sources.zip : main.pdf
	cp build/main.bbl main.bbl
	zip -r sources.zip figs images symbols abstract.tex acmart.cls background.tex calculus.tex conclusion.tex intro.tex let.tex macros.tex main.bbl main.tex polymorphism.tex preamble.tex references.bib related.tex symbols.tex typeholeinference.tex

supplement.pdf : *.tex
	$(LATEXMK) supplement.tex
	mv build/supplement.pdf supplement.pdf

supplement.zip : supplement.pdf
	zip -r supplement.zip supplement.pdf
	cd supplement && zip -r ../supplement.zip README.md agda hazel

.PHONY : clean
clean :
	rm -rf build
	rm -f *.pdf
	rm -f *.bbl
	rm -f **/*.agdai
	rm -f supplement.zip
