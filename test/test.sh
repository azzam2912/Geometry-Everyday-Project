#!/bin/bash

rm test-1.tex
rm test.aux
rm test.log
rm test.out
rm test.fdb_latexmk
rm test.pre
rm test-1.pre
rm test.fls
rm test.eps
rm test.synctex.gz

pdflatex test.tex
asy test-1.asy
pdflatex test.tex

rm test-1.tex
rm test.aux
rm test.log
rm test.out
rm test.fdb_latexmk
rm test.pre
rm test-1.pre
rm test.fls
rm test.eps
rm test.synctex.gz