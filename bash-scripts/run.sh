#!/bin/bash

# Run build.sh, build-problems.sh, and build-solutions.sh in parallel
echo "Running build.sh, build-problems.sh, and build-solutions.sh in parallel..."
bash bash-scripts/build.sh &
pid1=$!
bash bash-scripts/build-problems.sh &
pid2=$!
bash bash-scripts/build-solutions.sh &
pid3=$!

# Wait for all three scripts to finish
wait $pid1 $pid2 $pid3

echo "Running rename.sh..."
bash bash-scripts/rename.sh

echo "Running delete.sh..."
bash bash-scripts/delete.sh

echo "All scripts completed."