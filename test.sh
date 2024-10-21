#!/bin/bash

pdflatex test.tex
asy test-1.asy
pdflatex test.tex
bash delete.sh