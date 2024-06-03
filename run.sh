#!/bin/bash

# Run build.sh, build-problems.sh, and build-solutions.sh in parallel
echo "Running build.sh, build-problems.sh, and build-solutions.sh in parallel..."
bash build.sh &
pid1=$!
bash build-problems.sh &
pid2=$!
bash build-solutions.sh &
pid3=$!

# Wait for all three scripts to finish
wait $pid1 $pid2 $pid3

echo "Running rename.sh..."
bash rename.sh

echo "Running delete.sh..."
bash delete.sh

echo "All scripts completed."