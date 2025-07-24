#!/bin/bash

pdflatex main.tex
for i in {1..50}
do
    asy main-$i.asy
done
pdflatex main.tex

for i in {1..50}
do
    rm main-$i.pdf
    rm main-$i.asy
done