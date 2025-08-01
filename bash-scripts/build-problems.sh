#!/bin/bash
pdflatex main-problems.tex
for i in {1..50}
do
    asy main-problems-$i.asy
done
pdflatex main-problems.tex
pdflatex main-problems.tex