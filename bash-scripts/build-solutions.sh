#!/bin/bash
pdflatex main-solutions.tex
for i in {1..50}
do
    asy main-solutions-$i.asy
done
pdflatex main-solutions.tex
pdflatex main-solutions.tex