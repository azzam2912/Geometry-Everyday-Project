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

# #Run build.sh, build-solutions.sh in parallel first to get the cross reference right later
# echo "Running main-solutions.tex, and main.tex to get the cross reference right later..."
# pdflatex main-solutions.tex
# pid4=$!
# pdflatex main.tex
# pid5=$!

# #Wait for all two scripts to finish
# wait $pid4 $pid5

echo "Running rename.sh..."
bash bash-scripts/rename.sh

echo "Running delete.sh..."
bash bash-scripts/delete.sh

echo "All scripts completed."