#!/bin/bash

pdflatex main-problems.tex
for i in {1..50}
do
    asy main-problems-$i.asy
done
pdflatex main-problems.tex

for i in {1..50}
do
    rm main-problems-$i.pdf
    rm main-problems-$i.asy
done