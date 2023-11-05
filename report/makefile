main.pdf: main.dvi
	dvipdfmx main.dvi
	rm *.log *.aux *.dvi
	xdg-open main.pdf
main.dvi: main.tex source/*.tex
	platex main.tex
clean:
	rm *.pdf *.log *.aux *.dvi
	rm source/*.aux