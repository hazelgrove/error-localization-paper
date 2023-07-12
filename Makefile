LATEXMK ?= latexmk

.PHONY: all
all : main.pdf supplement.pdf

main.pdf : *.tex
	$(LATEXMK) main.tex
	mv build/main.pdf main.pdf

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
	rm -f **/*.agdai
	rm -f supplement.zip
