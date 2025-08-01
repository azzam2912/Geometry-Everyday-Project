#!/bin/bash

# Define the file patterns to delete
patterns=(
    "main-*.asy"
    "test-*.asy"
    "*.out"
    "*.aux"
    "*.fdb_latexmk"
    "*.log"
    "*.pre"
    "*.fls"
    "*.toc"
    "*.eps"
)

# Loop through the patterns and delete matching files
for pattern in "${patterns[@]}"; do
    files_to_delete=$(find . -type f -name "$pattern")
    if [ -n "$files_to_delete" ]; then
        echo "Deleting files matching pattern: $pattern"
        rm -v $files_to_delete
    fi
done

for i in {1..50}
do
    rm main-problems-$i.pdf
    rm main-problems-$i.asy
done

for i in {1..50}
do
    rm main-solutions-$i.pdf
    rm main-solutions-$i.asy
done

for i in {1..50}
do
    rm main-$i.pdf
    rm main-$i.asy
done