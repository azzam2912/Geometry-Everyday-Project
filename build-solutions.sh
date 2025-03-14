#!/bin/bash

pdflatex main-solutions.tex
for i in {1..40}
do
    asy main-solutions-$i.asy
done
pdflatex main-solutions.tex

for i in {1..40}
do
    rm main-solutions-$i.pdf
    rm main-solutions-$i.asy
done