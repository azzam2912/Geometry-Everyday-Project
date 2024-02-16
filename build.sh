#!/bin/bash

pdflatex main.tex
for i in {1..40}
do
    asy main-$i.asy
done
pdflatex main.tex

for i in {1..40}
do
    rm main-$i.pdf
    rm main-$i.asy
done