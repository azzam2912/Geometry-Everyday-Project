#!/bin/bash

pdflatex test/test.tex
asy test/test-1.asy
pdflatex test/test.tex
bash bash-scripts/delete.sh